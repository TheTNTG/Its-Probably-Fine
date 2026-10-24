extends Node

signal milestone_recorded(identifier: String, campaign: String)
const VERSION := 1
const DIRECTORY := "user://saves"
const CAMPAIGN := DIRECTORY + "/campaign.json"
const PROFILE := DIRECTORY + "/profile.json"
const ART = preload("res://scripts/apartment_visual.gd")
# Explicit allowlist: no animation, modal, node, audio or navigation references.
const NUMBERS := {
	"day": [1, 3], "time_minutes": [660, 1200], "difficulty": [0, 2],
	"research_progress": [0, 100], "work_sessions_remaining": [0, 4],
	"hunger": [0, 100], "mood": [0, 100], "work_streak": [0, 12],
	"unresolved_problem_count": [0, 100000], "sink_water_elapsed": [0, 31],
	"water_exposure": [0, 210], "mosquito_level": [0, 3],
	"clock_fraction": [0, 1], "world_accumulator": [0, 0.25], "world_elapsed": [0, 540],
	"research_next_chore": [0, 10000], "chore_cursor": [0, 3],
	"research_task_serial": [0, 1000000], "overnight_day": [0, 3],
	"next_mosquito_id": [0, 1000000], "mosquito_spawn_after": [0, 10000],
	"break_reminder_count": [0, 100000], "bed_protected_until": [0, 10000], "bed_mischief_day": [0, 3],
	"mosquito_target_id": [-1, 1000000], "batch_removed": [0, 3]
}
const INTEGERS := ["day", "time_minutes", "difficulty", "work_sessions_remaining", "work_streak", "unresolved_problem_count", "mosquito_level", "chore_cursor", "research_task_serial", "overnight_day", "next_mosquito_id", "break_reminder_count", "bed_protected_until", "bed_mischief_day", "mosquito_target_id", "batch_removed"]
const BOOLEANS := ["difficulty_locked", "first_work_done", "end_day_reminded", "proactive_fix_eligible", "tap_running", "break_reminded", "tutorial_skipped", "tutorial_finished", "robot_chore_resolved", "last_robot_swat", "mosquito_task", "research_swat"]
const MAPS := ["repairs", "chore_mess", "chore_repetitions", "chore_ready_at", "daily_time", "daily_time_history", "tutorial_seen", "response_counts"]
var player_profile := {"version": VERSION, "kind": "profile", "tutorial_completed": false, "tutorial_skipped": false, "completed_campaigns": [], "endings": [], "achievements": [], "milestones": {}, "audio": {}}
var profile_read_only := false
var last_error := ""
var recovery_note := ""
var campaign_id := ""
var loading := false
var pending_load: Dictionary = {}
var pending_autosave := false
var debounce := 0.0
var retry_after := 0.0
var profile_dirty := false


func _ready() -> void:
	process_mode = Node.PROCESS_MODE_ALWAYS
	var data := _read_recover(PROFILE, "profile")
	if not data.is_empty():
		player_profile.merge(data, true)
	elif FileAccess.file_exists(PROFILE) or not _revisions(PROFILE).is_empty():
		profile_read_only = true
		last_error = "Profile could not be read. Existing files are preserved; profile writes are disabled."
	for bus_name in ["Master", "SFX", "Ambience", "Music"]:
		if player_profile["audio"].has(bus_name):
			var index := AudioServer.get_bus_index(bus_name)
			if index >= 0:
				var value: float = player_profile["audio"][bus_name]
				AudioServer.set_bus_mute(index, value <= 0)
				AudioServer.set_bus_volume_db(index, linear_to_db(maxf(value, 0.0001)))


func _process(delta: float) -> void:
	retry_after = maxf(0.0, retry_after - delta)
	debounce = maxf(0.0, debounce - delta)
	if profile_dirty and debounce == 0 and retry_after == 0:
		_save_profile()
	if pending_autosave and debounce == 0 and retry_after == 0 and safe_reason().is_empty():
		if not save_campaign():
			retry_after = 30.0
			GameState.action_feedback.emit(last_error)


func _number(value: Variant, low: float, high: float) -> bool:
	return (value is int or value is float) and is_finite(float(value)) and float(value) >= low and float(value) <= high


func _vector(value: Variant) -> bool:
	return value is Array and value.size() == 2 and _number(value[0], 0, 320) and _number(value[1], 0, 214)


func _flag_map(value: Variant) -> bool:
	if not value is Dictionary or value.size() > 2000:
		return false
	for key in value:
		if not key is String or not value[key] is bool:
			return false
	return true


func _validate(data: Dictionary, kind: String) -> bool:
	if data.get("version") != VERSION or data.get("kind") != kind:
		return false
	if kind == "profile":
		for field in ["tutorial_completed", "tutorial_skipped"]:
			if data.has(field) and not data[field] is bool:
				return false
		for field in ["endings", "achievements", "completed_campaigns"]:
			if not data.get(field, []) is Array or data.get(field, []).size() > 10000:
				return false
			for item in data.get(field, []):
				if not item is String or item.length() > 128:
					return false
		if not data.get("milestones", {}) is Dictionary or not data.get("audio", {}) is Dictionary:
			return false
		for key in data.get("milestones", {}):
			if not _flag_map(data["milestones"][key]):
				return false
		for key in data.get("audio", {}):
			if not _number(data["audio"][key], 0, 1):
				return false
		return true
	if not data.get("id") is String or data["id"].is_empty() or data["id"].length() > 128 or not data.get("finished") is bool:
		return false
	if data["finished"]:
		return true # Valid tombstone must not fall back to an older live campaign.
	if not data.get("state") is Dictionary or not data.get("actors") is Dictionary or not data.get("story") is Dictionary or not data.get("robot") is Dictionary:
		return false
	var state: Dictionary = data["state"]
	for field in NUMBERS:
		if not state.has(field) or not _number(state[field], NUMBERS[field][0], NUMBERS[field][1]):
			return false
		if field in INTEGERS and float(state[field]) != floor(float(state[field])):
			return false
	for field in BOOLEANS:
		if not state.get(field) is bool:
			return false
	if float(state["time_minutes"]) + float(state["clock_fraction"]) + float(state["world_accumulator"]) > GameState.DAY_END + 0.00001 or float(state["clock_fraction"]) >= 1.0:
		return false
	for field in MAPS:
		if not state.get(field) is Dictionary:
			return false
	for field in ["repairs", "chore_mess", "chore_repetitions"]:
		if state[field].size() != GameState.REPAIR_ROUTINES.size():
			return false
		for key in state[field]:
			if key not in GameState.REPAIR_ROUTINES:
				return false
	for chore in GameState.REPAIR_ROUTINES:
		if not state["repairs"].get(chore) is bool or not _number(state["chore_mess"].get(chore), 0, 3) or not _number(state["chore_repetitions"].get(chore), 0, 100000):
			return false
	for field in ["chore_ready_at", "daily_time", "response_counts"]:
		for key in state[field]:
			if not _number(state[field][key], 0, 100000):
				return false
	for key in GameState.TIME_CATEGORIES:
		if not _number(state["daily_time"].get(key), 0, 540.25):
			return false
	for day_key in state["daily_time_history"]:
		if str(day_key) not in ["1", "2", "3"] or not state["daily_time_history"][day_key] is Dictionary:
			return false
		for category in GameState.TIME_CATEGORIES:
			if not _number(state["daily_time_history"][day_key].get(category), 0, 540.25):
				return false
		for value in state["daily_time_history"][day_key].values():
			if not _number(value, 0, 540.25):
				return false
	if not _flag_map(state["tutorial_seen"]) or not _flag_map(data["story"].get("seen", {})) or not _vector(data["actors"].get("judy")) or not _vector(data["actors"].get("tiptop")):
		return false
	for key in ["morning_day", "goodnight_day"]:
		if not _number(data["robot"].get(key, 0), 0, 3):
			return false
	if not _number(data["story"].get("talk_count", 0), 0, 100000) or not data["robot"].get("thought_counts", {}) is Dictionary:
		return false
	for value in data["robot"].get("thought_counts", {}).values():
		if not _number(value, 0, 100000):
			return false
	if state.get("research_task") not in ["plant", "sink", "bookshelf", "bed", ""] or state.get("last_robot_chore") not in ["plant", "sink", "bookshelf", "bed", ""]:
		return false
	if not data.get("mosquitoes", []) is Array or data.get("mosquitoes", []).size() > 6:
		return false
	var ids: Array = []
	for fly in data.get("mosquitoes", []):
		if not fly is Dictionary or not _number(fly.get("id"), 0, 1000000) or int(fly["id"]) in ids or not _vector(fly.get("position")) or not _number(fly.get("count", 0), 0, 1000000):
			return false
		ids.append(int(fly["id"]))
	return true


func _read(path: String, kind: String) -> Dictionary:
	var file := FileAccess.open(path, FileAccess.READ)
	if file == null or file.get_length() > 4000000:
		return {}
	var data: Variant = JSON.parse_string(file.get_as_text())
	file.close()
	return data if data is Dictionary and _validate(data, kind) else {}


func _revisions(path: String) -> Array[String]:
	var result: Array[String] = []
	for filename in (DirAccess.get_files_at(DIRECTORY) if DirAccess.dir_exists_absolute(DIRECTORY) else PackedStringArray()):
		if filename.begins_with(path.get_file() + ".previous.") and filename.ends_with(".json"):
			result.append(DIRECTORY + "/" + filename)
	result.sort()
	result.reverse()
	return result


func _read_recover(path: String, kind: String) -> Dictionary:
	var data := _read(path, kind)
	if not data.is_empty():
		return data
	for backup in _revisions(path):
		data = _read(backup, kind)
		if not data.is_empty():
			recovery_note = "Recovered a previous valid %s checkpoint. Original files are preserved." % kind
			return data
	return {}


func _write(path: String, data: Dictionary, kind: String) -> bool:
	if not _validate(data, kind):
		last_error = "Save data failed validation; existing files were preserved."
		return false
	if DirAccess.make_dir_recursive_absolute(DIRECTORY) != OK:
		last_error = "Cannot create the save directory."
		return false
	var suffix := "%020d_%s" % [int(Time.get_unix_time_from_system() * 1000000), Crypto.new().generate_random_bytes(4).hex_encode()]
	var temporary := path + ".pending." + suffix
	var file := FileAccess.open(temporary, FileAccess.WRITE)
	if file == null:
		last_error = "Cannot write save: error %d." % FileAccess.get_open_error()
		return false
	file.store_string(JSON.stringify(data, "\t"))
	file.flush()
	var error := file.get_error()
	file.close()
	if error != OK or _read(temporary, kind).is_empty():
		last_error = "Save write could not be verified; previous checkpoint is intact."
		return false
	var backup := path + ".previous." + suffix + ".json"
	var had_previous := FileAccess.file_exists(path)
	if had_previous and DirAccess.rename_absolute(path, backup) != OK:
		last_error = "Cannot preserve previous save; replacement cancelled."
		return false
	if DirAccess.rename_absolute(temporary, path) != OK:
		if had_previous:
			DirAccess.rename_absolute(backup, path)
		last_error = "Cannot install checkpoint; previous save retained or available in recovery files."
		return false
	last_error = ""
	return true


func _save_profile() -> bool:
	if profile_read_only:
		profile_dirty = false
		return false
	if _write(PROFILE, player_profile, "profile"):
		profile_dirty = false
		return true
	retry_after = 30.0
	return false


func remember_tutorial(completed: bool) -> void:
	player_profile["tutorial_completed"] = bool(player_profile["tutorial_completed"]) or completed
	if not completed:
		player_profile["tutorial_skipped"] = true
	profile_dirty = true
	_save_profile()


func audio_preference(bus: String, value: float) -> void:
	player_profile["audio"][bus] = clampf(value / 100.0, 0.0, 1.0)
	profile_dirty = true
	debounce = 0.7


func _exit_tree() -> void:
	if profile_dirty and not profile_read_only:
		_save_profile()


func new_campaign(force_tutorial: bool = false) -> void:
	campaign_id = Crypto.new().generate_random_bytes(16).hex_encode()
	pending_autosave = false
	loading = false
	if not force_tutorial and (player_profile["tutorial_completed"] or player_profile["tutorial_skipped"]):
		GameState.tutorial_finished = true
		GameState.tutorial_skipped = true
	request_autosave("new_campaign")


func request_autosave(_event: String) -> void:
	if not loading and not campaign_id.is_empty() and not GameState.game_finished:
		pending_autosave = true
		debounce = 0.75


func safe_reason(manual: bool = false) -> String:
	var scene: Node = get_tree().current_scene
	if loading or not is_instance_valid(scene) or not scene.has_node("HUD") or campaign_id.is_empty():
		return "Saving is available during a campaign."
	if GameState.research_active or not GameState.personal_activity.is_empty() or GameState.household_busy or GameState.repair_in_progress or scene.get_node("Player").animation_busy:
		return "Finish or eject the current activity before saving."
	var hud: Node = scene.get_node("HUD")
	if GameState.day_ended or GameState.game_finished or GameState.ending_day_pending or hud.transitioning:
		return "Wait for the next playable day before saving."
	if GameState.notification_active or hud.dialogue_overlay.visible or hud.repair_panel.visible or hud.loop_panel.visible or hud._household_open() or hud._eject_open() or hud.sleep_dialogue_pending:
		return "Close the conversation or activity menu before saving."
	if not hud.dialogue_lines.is_empty() or not hud.deferred_story_events.is_empty() or not hud.pending_feedback.is_empty() or hud.morning_pending_day != 0:
		return "Resume and finish the pending conversation before saving."
	if get_tree().paused and not (manual and hud._pause_open()):
		return "Resume gameplay before saving."
	return ""


func save_campaign(manual: bool = false) -> bool:
	last_error = safe_reason(manual)
	if not last_error.is_empty():
		return false
	var scene: Node = get_tree().current_scene
	var state := {}
	for field in NUMBERS.keys() + BOOLEANS + MAPS + ["research_task", "last_robot_chore"]:
		state[field] = GameState.get(field)
	var judy: Node2D = scene.get_node("Player")
	var robot: Node2D = scene.get_node("TipTop")
	var hud: Node = scene.get_node("HUD")
	var flies: Array = []
	for id in GameState.mosquitoes:
		var fly: Dictionary = GameState.mosquitoes[id]
		var point: Vector2 = fly["position"]
		flies.append({"id": int(id), "position": [point.x, point.y], "count": fly["count"]})
	var data := {"version": VERSION, "kind": "campaign", "id": campaign_id, "finished": false, "state": state, "actors": {"judy": [judy.global_position.x, judy.global_position.y], "tiptop": [robot.global_position.x, robot.global_position.y]}, "mosquitoes": flies, "story": {"seen": hud.story_seen, "talk_count": hud.tiptop_talk_count}, "robot": {"morning_day": robot.morning_day, "goodnight_day": robot.goodnight_day, "thought_counts": robot.thought_counts}}
	if not _write(CAMPAIGN, data, "campaign"):
		return false
	pending_autosave = false
	return true


func campaign_data() -> Dictionary:
	var data := _read_recover(CAMPAIGN, "campaign")
	if data.is_empty() and (FileAccess.file_exists(CAMPAIGN) or not _revisions(CAMPAIGN).is_empty()):
		last_error = "No compatible campaign checkpoint could be read. Existing files are preserved."
	return data


func can_continue() -> bool:
	var data := campaign_data()
	return not data.is_empty() and not bool(data["finished"]) and not data["id"] in player_profile["completed_campaigns"]


func prepare_continue() -> bool:
	pending_load = campaign_data()
	if pending_load.is_empty() or pending_load["finished"] or pending_load["id"] in player_profile["completed_campaigns"]:
		last_error = "No compatible active save could be read. Existing files were preserved."
		return false
	loading = true
	pending_autosave = false
	get_tree().paused = true
	return true


func _ground(actor: CharacterBody2D, wanted: Vector2) -> Vector2:
	var collision: CollisionShape2D = actor.get_node("CollisionShape2D")
	var query := PhysicsShapeQueryParameters2D.new()
	query.shape = collision.shape
	query.collision_mask = actor.collision_mask
	var scene: Node = get_tree().current_scene
	query.exclude = [scene.get_node("Player").get_rid(), scene.get_node("TipTop").get_rid()]
	var candidates: Array[Vector2] = [wanted]
	for y in range(5, 24):
		for x in range(6, 35):
			candidates.append(Vector2(x, y) * 8)
	candidates.sort_custom(func(a: Vector2, b: Vector2): return a.distance_squared_to(wanted) < b.distance_squared_to(wanted))
	for point in candidates:
		if not Geometry2D.is_point_in_polygon(point, PackedVector2Array(ART.ROOM_EDGE)):
			continue
		query.transform = Transform2D(0, point + collision.position)
		if actor.get_world_2d().direct_space_state.intersect_shape(query, 1).is_empty():
			return point
	return Vector2.INF


func restore_room() -> void:
	await get_tree().physics_frame
	var scene: Node = get_tree().current_scene
	if not is_instance_valid(scene) or not scene.has_node("Player") or pending_load.is_empty():
		loading = false
		last_error = "Continue was interrupted; the saved checkpoint is intact."
		return
	var judy: CharacterBody2D = scene.get_node("Player")
	var robot: CharacterBody2D = scene.get_node("TipTop")
	var hud: Node = scene.get_node("HUD")
	var actors: Dictionary = pending_load["actors"]
	var player_point := _ground(judy, Vector2(actors["judy"][0], actors["judy"][1]))
	var robot_point := _ground(robot, Vector2(actors["tiptop"][0], actors["tiptop"][1]))
	if not player_point.is_finite() or not robot_point.is_finite():
		last_error = "Could not restore a walkable position. Save files are intact."
		loading = false
		get_tree().change_scene_to_file("res://scenes/title.tscn")
		return
	GameState.restart()
	var state: Dictionary = pending_load["state"]
	for field in NUMBERS:
		GameState.set(field, int(state[field]) if field in INTEGERS else float(state[field]))
	for field in BOOLEANS + MAPS + ["research_task", "last_robot_chore"]:
		GameState.set(field, state[field])
	GameState.tiptop_fixed = not GameState.repairs.values().has(false)
	GameState.daily_time_history = {}
	for key in state["daily_time_history"]:
		GameState.daily_time_history[int(key)] = state["daily_time_history"][key]
	judy.global_position = player_point
	robot.global_position = robot_point
	judy.velocity = Vector2.ZERO
	robot.velocity = Vector2.ZERO
	judy.reset_physics_interpolation()
	robot.reset_physics_interpolation()
	robot.display_position = robot_point
	robot.last_day = GameState.day
	robot.morning_day = int(pending_load["robot"].get("morning_day", GameState.day))
	robot.goodnight_day = int(pending_load["robot"].get("goodnight_day", 0))
	robot.thought_counts = pending_load["robot"].get("thought_counts", {})
	robot.finished_chore_serial = GameState.research_task_serial if GameState.robot_chore_resolved else -1
	robot.session_serial = -1
	robot._state_changed() # Re-approach an unfinished task; never replay its outcome remotely.
	robot._map_obstacles()
	GameState.mosquitoes.clear()
	for fly in pending_load.get("mosquitoes", []):
		var point := Vector2(fly["position"][0], fly["position"][1])
		var cell := Vector2i((point / 8).round())
		if not robot.grid.is_in_boundsv(cell) or robot.grid.is_point_solid(cell):
			point = Vector2(robot._open_cell(point)) * 8
		var id := int(fly["id"])
		GameState.mosquitoes[id] = {"position": point, "previous": point, "velocity": Vector2.ZERO, "turn": 0.0, "count": int(fly.get("count", id)), "direction": Vector2.RIGHT}
		GameState.next_mosquito_id = maxi(GameState.next_mosquito_id, id + 1)
	GameState.mosquito_level = int(ceil(GameState.mosquitoes.size() / 2.0))
	if GameState.research_swat:
		GameState.mosquito_batch = GameState.mosquitoes.keys().slice(0, 3 - GameState.batch_removed)
		if GameState.mosquitoes.has(GameState.mosquito_target_id):
			GameState.mosquito_batch.erase(GameState.mosquito_target_id)
			GameState.mosquito_batch.push_front(GameState.mosquito_target_id)
		if not GameState.mosquito_batch.is_empty():
			GameState.mosquito_target_id = int(GameState.mosquito_batch[0])
		else:
			GameState.robot_chore_resolved = true
			GameState.research_next_chore = GameState.world_elapsed + 0.5
	if player_profile["tutorial_completed"] or player_profile["tutorial_skipped"]:
		GameState.tutorial_finished = true
		GameState.tutorial_skipped = true
	hud.story_seen = pending_load["story"].get("seen", {})
	hud.tiptop_talk_count = int(pending_load["story"].get("talk_count", 0))
	hud.morning_pending_day = 0
	hud.loop_panel.hide()
	hud.difficulty_controls.hide()
	hud.difficulty_description.hide()
	hud.transition_cover.hide()
	hud.transition_title.hide()
	campaign_id = pending_load["id"]
	pending_load = {}
	loading = false
	GameState.state_changed.emit()
	get_tree().paused = false
	if not recovery_note.is_empty():
		GameState.action_feedback.emit(recovery_note)


func milestone(identifier: String, persist: bool = true) -> void:
	if campaign_id.is_empty():
		return
	var events: Dictionary = player_profile["milestones"].get(campaign_id, {})
	if events.has(identifier):
		return
	events[identifier] = true
	player_profile["milestones"][campaign_id] = events
	profile_dirty = true
	if persist:
		_save_profile()
	milestone_recorded.emit(identifier, campaign_id)


func record_ending(identifier: String) -> void:
	if campaign_id.is_empty():
		return
	if not campaign_id in player_profile["completed_campaigns"]:
		player_profile["completed_campaigns"].append(campaign_id)
	if not identifier in player_profile["endings"]:
		player_profile["endings"].append(identifier)
	milestone("ending_" + identifier, false)
	if GameState.difficulty == 2:
		milestone("campaign_hard", false)
	profile_dirty = true
	_save_profile()
	pending_autosave = false
	if not _write(CAMPAIGN, {"version": VERSION, "kind": "campaign", "id": campaign_id, "finished": true}, "campaign"):
		push_warning(last_error)
