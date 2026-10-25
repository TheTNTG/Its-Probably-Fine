extends Node

# Presentation only. Audio has its own RNG and real-time cadence, never the
# simulation's random sequence, clock, task selection or completion logic.
const LAYER = preload("res://scripts/audio_layer.gd")
const APARTMENT_THEME_PATH := "res://assets/audio/music/chilllofir-loop.ogg"
const ROOT := "res://assets/audio/"
# Robot travel is intentionally independent of clearly audible task sounds.
const MOTOR_DB := -38.0
const TYPING_DB := -4.0
const CUBE_DB := -6.0
const EATING_DB := -9.0
# The Music bus is the user's volume control. Avoid a second near-silent mix
# underneath it, especially now that activity SFX have a prominent mix.
const MUSIC_GAME_DB := -8.0
const MUSIC_MENU_DB := -9.0
const FILES := {
	"typing": "sfx/research/typing.wav",
	"key_clack": "sfx/research/key_clack.wav",
	"cube": "sfx/leisure/cube.wav",
	"cube_click": "sfx/leisure/cube_click.wav",
	"eating": "sfx/eating/eating.wav",
	"cutlery": "sfx/eating/cutlery.wav",
	"fridge_open": "sfx/eating/fridge_open.wav",
	"fridge_close": "sfx/eating/fridge_close.wav",
	"reel_giggle": "sfx/leisure/reel_giggle.wav",
	"reel_dog": "sfx/leisure/reel_dog.wav",
	"books": "sfx/environment/books.wav",
	"books_alt": "sfx/environment/books_alt.wav",
	"books_third": "sfx/environment/books_third.wav",
	"book_fall": "sfx/environment/book_fall.wav",
	"ratchet": "sfx/repair/ratchet.wav",
	"clank": "sfx/repair/clank.wav",
	"paper": "sfx/ui/paper.wav",
	"desk": "sfx/research/desk.wav",
	"cloth": "sfx/environment/cloth.wav",
	"water_plant": "sfx/environment/water_plant.wav",
	"wipe": "sfx/environment/wipe.wav",
	"drip": "sfx/environment/drip.wav",
	"room": "sfx/environment/room.wav",
	"fridge": "sfx/environment/fridge.wav",
	"tap": "sfx/environment/tap.wav",
	"servo": "sfx/tiptop/servo.wav",
	"mosquito": "sfx/mosquito/mosquito.wav",
	"step_0": "sfx/environment/step_0.wav",
	"step_1": "sfx/environment/step_1.wav",
	"step_2": "sfx/environment/step_2.wav",
	"screwdriver": "sfx/repair/screwdriver.wav",
	"chewing": "sfx/eating/chewing.wav",
	"typing_alt": "sfx/research/typing_alt.wav",
	"cup": "sfx/eating/cup.wav",
	"book_stack": "sfx/environment/book_stack.wav",
	"laser_0": "sfx/leisure/laser_0.wav",
	"laser_1": "sfx/leisure/laser_1.wav",
	"explosion": "sfx/leisure/explosion.wav",
	"score": "sfx/leisure/score.wav",
	"reel_boing": "sfx/leisure/reel_boing.wav",
	"fault": "sfx/tiptop/fault.wav",
	"ui_hover": "sfx/ui/ui_hover.wav",
	"ui_click": "sfx/ui/ui_click.wav",
	"confirm": "sfx/ui/confirm.wav",
	"cancel": "sfx/ui/cancel.wav",
	"menu": "sfx/ui/menu.wav",
	"resume": "sfx/ui/resume.wav",
	"swipe": "sfx/leisure/swipe.wav",
	"swat": "sfx/mosquito/swat.wav",
	"swat_alt": "sfx/mosquito/swat_alt.wav",
}
# Prepared complete clips; native AudioStreamPlayers own their end times.
const CUES := {
	"paper": ["paper", -14, 0.44, 0.0],
	"desk": ["desk", -10, 0.1944, 0.0],
	"fridge_open": ["fridge_open", -11, 2.04, 0.0],
	"fridge_close": ["fridge_close", -10, 1.0213, 0.0],
	"meal": ["cutlery", -7, 1.1172, 0.0],
	"eating": ["eating", -9, 5.0955, 0.0],
	"chewing": ["chewing", -7, 3.0303, 0.0],
	"cup": ["cup", -10, 0.3062, 0.0],
	"cube": ["cube_click", -10, 0.44, 0.0],
	"bedding": ["cloth", -11, 1.76, 0.0],
	"repair": ["ratchet", -6, 3.04, 0.0],
	"ratchet": ["ratchet", -6, 3.04, 0.0],
	"screwdriver": ["screwdriver", -7, 2.1356, 0.0],
	"clank": ["clank", -7, 0.3175, 0.0],
	"clean": ["wipe", -9, 2.04, 0.0],
	"books": ["books", -7, 2.34, 0.0],
	"books_alt": ["books_alt", -7, 2.34, 0.0],
	"books_third": ["books_third", -7, 2.34, 0.0],
	"book_stack": ["book_stack", -8, 0.4268, 0.0],
	"book_fall": ["book_fall", -5, 3.4415, 0.0],
	"watering": ["water_plant", -9, 3.04, 0.0],
	"drip": ["drip", -12, 1.24, 0.0],
	"swat": ["swat", -4, 0.956, 0.0],
	"swat_alt": ["swat_alt", -4, 1.2028, 0.0],
	"fault": ["fault", -6, 1.54, 0.0],
	"laser_0": ["laser_0", -8, 0.2754, 0.0],
	"laser_1": ["laser_1", -8, 0.2951, 0.0],
	"explosion": ["explosion", -8, 0.8175, 0.0],
	"score": ["score", -11, 1.0522, 0.0],
	"swipe": ["swipe", -14, 1.04, 0.0],
	"reel_giggle": ["reel_giggle", -7, 0.5393, 0.0],
	"reel_dog": ["reel_dog", -9, 0.2863, 0.0],
	"reel_boing": ["reel_boing", -10, 0.4254, 0.0],
	"click": ["ui_click", -9, 0.05, 0.0],
	"hover": ["ui_hover", -18, 0.0632, 0.0],
	"confirm": ["confirm", -12, 0.3298, 0.0],
	"cancel": ["cancel", -13, 0.1039, 0.0],
	"complete": ["confirm", -10, 0.3298, 0.0],
	"menu": ["menu", -14, 0.1878, 0.0],
	"resume": ["resume", -14, 0.1878, 0.0],
	"page": ["paper", -20, 0.44, 0.0],
	"key_clack": ["key_clack", -7, 0.2, 0.0],
	"robot_done": ["confirm", -15, 0.3298, 0.0],
}
var streams: Dictionary = {}
var layers: Dictionary = {}
var world_voices: Array[AudioStreamPlayer2D] = []
var ui_voices: Array[AudioStreamPlayer] = []
var rng := RandomNumberGenerator.new()
var cooldowns: Dictionary = {}
var room: Node
var world_audio: Node2D
var judy: CharacterBody2D
var robot: CharacterBody2D
var hud: CanvasLayer
var previous_feet := Vector2.ZERO
var step_distance := 0.0
var walking := false
var activity := ""
var activity_wait := 0.0
var arcade_count := 0
var reel_index := -1
var reel_next := ""
var robot_wait := 0.0
var robot_was_working := false
var dish_audio_step := 0
var mosquito_buzz_phase := 0.0
var typing_cycle_left := 0.0
var alternate_typing := false
var repair_sound_left := 0.0
var repair_sound_wait := 0.0
var repair_sound_step := 0
var last_task_serial := -1
var suppress_depth := 0
var ui_wait := 0.0
var fridge_close_after := 0.0
var mess_snapshot: Dictionary = {}
var water_stage := 0
var tap_was_running := false
var music: AudioStreamPlayer
var music_gain := 0.0


func _ready() -> void:
	process_mode = Node.PROCESS_MODE_ALWAYS
	rng.randomize()
	_initialise_music()
	for key in FILES:
		streams[key] = _load_sfx(ROOT + FILES[key])
		if streams[key] == null:
			push_error("Missing or undecodable SFX: " + ROOT + FILES[key])
	for index in range(3):
		var voice := AudioStreamPlayer.new()
		voice.bus = "SFX"
		add_child(voice)
		ui_voices.append(voice)
	get_tree().node_added.connect(_watch_control)
	for node in get_tree().root.find_children("*", "BaseButton", true, false):
		_watch_control(node)
	GameState.state_changed.connect(_activity_state_changed)


func _initialise_music() -> void:
	if is_instance_valid(music):
		return
	if AudioServer.get_bus_index("Music") < 0:
		AudioServer.add_bus()
		var bus := AudioServer.bus_count - 1
		AudioServer.set_bus_name(bus, "Music")
		AudioServer.set_bus_send(bus, "Master")
		AudioServer.set_bus_volume_db(bus, -6.0)
		# Recover routing without overwriting the player's persisted preference.
		var preferences: Dictionary = SaveStore.player_profile.get("audio", {})
		if preferences.has("Music"):
			var value: float = preferences["Music"]
			AudioServer.set_bus_mute(bus, value <= 0.0)
			AudioServer.set_bus_volume_db(bus, linear_to_db(maxf(value, 0.0001)))
	music = AudioStreamPlayer.new()
	music.name = "ApartmentTheme"
	music.process_mode = Node.PROCESS_MODE_ALWAYS
	music.bus = "Music"
	music.volume_db = MUSIC_MENU_DB
	music_gain = db_to_linear(MUSIC_MENU_DB)
	add_child(music)
	# Prefer the editor/export import, preserving Godot's normal stream setup.
	# An unimported source still has a native OGG fallback, never a fatal preload.
	var theme_stream: AudioStreamOggVorbis
	if ResourceLoader.exists(APARTMENT_THEME_PATH, "AudioStreamOggVorbis"):
		theme_stream = load(APARTMENT_THEME_PATH) as AudioStreamOggVorbis
	if theme_stream == null and FileAccess.file_exists(APARTMENT_THEME_PATH):
		theme_stream = AudioStreamOggVorbis.load_from_buffer(FileAccess.get_file_as_bytes(APARTMENT_THEME_PATH))
	if theme_stream != null and theme_stream.get_length() > 0.0:
		theme_stream.loop = true
		theme_stream.loop_offset = 0.0
		# Start after scene/autoload initialization, including the paused title.
		play_music.call_deferred(theme_stream)
	else:
		push_error("BGM unavailable or undecodable: " + APARTMENT_THEME_PATH + ". Reimport this original OGG; no replacement track was used.")


func _watch_control(node: Node) -> void:
	if node is BaseButton and not node.has_meta("cozy_audio"):
		node.set_meta("cozy_audio", true)
		node.pressed.connect(_button_pressed.bind(node))
		node.mouse_entered.connect(_hover_control.bind(node))
		node.focus_entered.connect(_hover_control.bind(node))


func _hover_control(button: BaseButton) -> void:
	if button.is_visible_in_tree() and not button.disabled:
		play_ui("hover")


func _button_pressed(button: BaseButton) -> void:
	if not is_instance_valid(button):
		return
	# Copy edits must not change the existing cue associated with a button.
	play_ui(GameText.button_cue((button as Button).text) if button is Button else "click")


func _load_sfx(path: String) -> AudioStream:
	# Use Godot's cached imported resource first, including remapped exports.
	if ResourceLoader.exists(path, "AudioStreamWAV"):
		var imported: AudioStream = load(path) as AudioStream
		if imported != null and imported.get_length() > 0.0:
			return imported
	# All active SFX now have verified PCM files; an unimported checkout works too.
	if FileAccess.file_exists(path):
		match path.get_extension():
			"mp3":
				return AudioStreamMP3.load_from_buffer(FileAccess.get_file_as_bytes(path))
			"ogg":
				return AudioStreamOggVorbis.load_from_file(path)
			"wav":
				return AudioStreamWAV.load_from_file(path)
	return null


func _attach_room(scene: Node) -> void:
	room = scene
	judy = room.get_node("Player")
	robot = room.get_node("TipTop")
	hud = room.get_node("HUD")
	world_audio = Node2D.new()
	world_audio.name = "ApartmentAudio"
	world_audio.process_mode = Node.PROCESS_MODE_ALWAYS
	room.add_child(world_audio)
	var listener := AudioListener2D.new()
	judy.add_child(listener)
	listener.make_current()
	for index in range(6):
		var voice := AudioStreamPlayer2D.new()
		voice.bus = "SFX"
		voice.max_distance = 230.0
		voice.attenuation = 0.65
		voice.panning_strength = 0.5
		world_audio.add_child(voice)
		world_voices.append(voice)
	for key in ["room", "fridge", "tap", "servo", "mosquito", "typing", "typing_alt", "cube", "eating"]:
		var layer := Node2D.new()
		layer.set_script(LAYER)
		world_audio.add_child(layer)
		var bus := "Ambience" if key in ["room", "fridge"] else ("RobotMovement" if key == "servo" else "SFX")
		var personal: bool = key in ["typing", "typing_alt", "cube", "eating"]
		# Prepared files already contain the audible excerpt, starting at zero.
		layer.call("setup", streams[key], bus, key != "room" and not personal, 0.0, 18.0 if key == "room" else 8.0)
		if personal:
			layer.set("overlap", 0.045)
			layer.set("fade_in", 0.04)
		layers[key] = layer
	previous_feet = judy.global_position
	step_distance = 0.0
	walking = false
	last_task_serial = -1
	robot_was_working = false
	dish_audio_step = 0
	mosquito_buzz_phase = 0.0
	mess_snapshot = GameState.chore_mess.duplicate()
	water_stage = int(GameState.sink_water_elapsed / 8.0)
	tap_was_running = GameState.tap_running
	fridge_close_after = 0.0


func _world_allowed() -> bool:
	return is_instance_valid(room) and is_instance_valid(hud) and not get_tree().paused and not bool(hud.get("transitioning")) and not GameState.day_ended and not GameState.game_finished and suppress_depth == 0 and not GameState.activity_skip_busy


func _process(delta: float) -> void:
	_update_music(delta)
	ui_wait = maxf(0.0, ui_wait - delta)
	for key in cooldowns:
		cooldowns[key] = maxf(0.0, float(cooldowns[key]) - delta)
	var scene: Node = get_tree().current_scene
	if scene != room or not is_instance_valid(room):
		repair_sound_left = 0.0
		for voice in ui_voices:
			if bool(voice.get_meta("activity", false)):
				voice.stop()
		if is_instance_valid(world_audio):
			world_audio.queue_free()
		world_voices.clear()
		layers.clear()
		activity = ""
		room = null
		if is_instance_valid(scene) and scene.has_node("Player") and scene.has_node("TipTop") and scene.has_node("HUD"):
			_attach_room(scene)
	if not is_instance_valid(room):
		return
	if SaveStore.loading or bool(hud.get("transitioning")) or bool(hud.call("_pause_open")):
		repair_sound_left = 0.0
		for voice in ui_voices:
			if bool(voice.get_meta("activity", false)):
				voice.stop()
	_update_repair_audio(delta)
	var active := _world_allowed()
	if not active:
		for voice in world_voices:
			voice.stop()
		for key in ["typing", "typing_alt", "cube", "eating"]:
			layers[key].call("stop_now")
	var sink: Node2D = room.get_node("Sink")
	layers["room"].call("set_level", -29.0, active)
	layers["fridge"].global_position = room.get_node("Fridge").global_position
	layers["fridge"].call("set_level", -29.0, active)
	layers["tap"].global_position = sink.global_position
	var washing_dishes: bool = str(robot.get("task_outcome")) == "working" and not bool(robot.get("swatting")) and GameState.research_task == "sink" and GameState.repairs["sink"] and GameState.sink_dirty_dishes
	layers["tap"].call("set_level", -13.0, active and (GameState.tap_running or washing_dishes))
	layers["servo"].global_position = robot.global_position
	# Physics velocity persists between render frames, including at 120 Hz.
	var robot_moving := robot.velocity.length() > 2.0
	layers["servo"].call("set_level", MOTOR_DB, active and robot_moving)
	var nearest := INF
	var fly_position := sink.global_position
	for id in GameState.mosquitoes:
		var point: Vector2 = GameState.mosquitoes[id]["position"]
		var distance := judy.global_position.distance_to(point)
		if distance < nearest:
			nearest = distance
			fly_position = point
	layers["mosquito"].global_position = fly_position
	# One spatial recording, not a full-volume loop per insect. More insects
	# lengthen each buzzing visit; silence between visits avoids a steady whine.
	if GameState.mosquitoes.is_empty():
		mosquito_buzz_phase = 0.0
		layers["mosquito"].call("stop_now")
	else:
		if active:
			mosquito_buzz_phase = fposmod(mosquito_buzz_phase + delta, 6.0)
		var buzz_window := 2.2 + minf(2.0, (GameState.mosquitoes.size() - 1) * 0.4)
		layers["mosquito"].call("set_level", -16.0, active and mosquito_buzz_phase < buzz_window)
	layers["typing"].global_position = room.get_node("Desk").global_position
	if not active:
		previous_feet = judy.global_position
		walking = false
		step_distance = 0.0
		return
	_update_steps(delta)
	if fridge_close_after > 0:
		fridge_close_after = maxf(0.0, fridge_close_after - delta)
		if fridge_close_after == 0:
			play_world("fridge_close", room.get_node("Fridge").global_position)
	_update_activity(delta)
	_update_robot(delta)


func _update_steps(_delta: float) -> void:
	var distance := judy.global_position.distance_to(previous_feet)
	previous_feet = judy.global_position
	if distance > 12.0 or not judy.get_node("Visual").visible or judy.velocity.length() < 5.0:
		step_distance = 0.0
		walking = false
		return
	if not walking and distance > 0.001:
		walking = true
		step_distance = 0.0
		# Start on the first actual movement, not after walking 24 units.
		cooldowns.erase("step:")
		play_world("step", judy.global_position)
		return
	step_distance += distance
	if step_distance >= 24.0:
		step_distance = fmod(step_distance, 24.0)
		play_world("step", judy.global_position)


func _update_activity(delta: float) -> void:
	var researching: bool = GameState.research_active and GameState.research_elapsed < GameState.research_duration
	var current := "research" if researching else GameState.personal_activity
	if current != activity:
		stop_activity(false)
		activity = current
		activity_wait = 0.0
		arcade_count = 0
		typing_cycle_left = rng.randf_range(8.0, 12.0)
		alternate_typing = false
		reel_index = -1
		reel_next = ""
		if current == "research":
			play_world("desk", judy.global_position, true)
	# Recorded key/cube/food loops continue for the entire actual activity.
	# Their source recordings supply natural internal variation and short pauses.
	if activity == "research":
		typing_cycle_left -= delta
		if typing_cycle_left <= 0.0:
			alternate_typing = not alternate_typing
			typing_cycle_left = rng.randf_range(8.0, 12.0)
	layers["typing"].call("set_level", TYPING_DB, activity == "research" and not alternate_typing)
	layers["typing_alt"].call("set_level", TYPING_DB, activity == "research" and alternate_typing)
	layers["cube"].call("set_level", CUBE_DB, activity == "cube")
	layers["eating"].call("set_level", EATING_DB, activity == "eat")
	if activity.is_empty():
		return
	activity_wait -= delta
	if activity_wait > 0:
		return
	# Cadence stays in real seconds at 1x and 6x; pitch never follows playback.
	match activity:
		"research":
			play_world("key_clack" if rng.randf() < 0.7 else "paper", judy.global_position, true)
			activity_wait = rng.randf_range(2.0, 4.0)
		"eat":
			var food_cue: String = ["meal", "chewing", "cup"][arcade_count % 3]
			arcade_count += 1
			play_world(food_cue, judy.global_position, true)
			activity_wait = rng.randf_range(2.0, 3.2)
		"cube":
			play_world("cube", judy.global_position, true)
			activity_wait = rng.randf_range(3.0, 5.0)
		"games":
			arcade_count += 1
			var game_cue := "explosion" if arcade_count % 7 == 0 else "laser_%d" % rng.randi_range(0, 1)
			if arcade_count % 23 == 0:
				game_cue = "score"
			play_world(game_cue, judy.global_position, true)
			activity_wait = rng.randf_range(0.24, 0.48)
		"reels":
			if reel_next.is_empty():
				play_world("swipe", judy.global_position, true)
				# Rotate recognizably different, legally sourced short clips.
				reel_index = (reel_index + rng.randi_range(1, 2)) % 3
				reel_next = ["reel_giggle", "reel_dog", "reel_boing"][reel_index]
				activity_wait = 0.28
			else:
				play_world(reel_next, judy.global_position, true)
				reel_next = ""
				activity_wait = rng.randf_range(0.9, 1.6)
		_:
			activity_wait = 1.0


func _update_robot(delta: float) -> void:
	if str(robot.get("task_outcome")) != "working" or bool(robot.get("swatting")):
		for voice in world_voices:
			if str(voice.get_meta("owner", "")) == "robot_task":
				voice.stop()
		robot_wait = 0.0
		if robot_was_working and str(robot.get("task_outcome")) == "completed":
			# The scheduler may already have selected the next job at 6x.
			play_world("book_stack" if int(robot.get("visit")) == 2 else "robot_done", robot.global_position)
		robot_was_working = false
		return
	robot_was_working = true
	var serial: int = robot.get("session_serial")
	if serial != last_task_serial:
		last_task_serial = serial
		robot_wait = 0.0
		dish_audio_step = 0
	robot_wait -= delta
	if robot_wait > 0.0:
		return
	var cue: String = {"sink": "meal", "plant": "watering", "bookshelf": "books", "bed": "bedding"}.get(GameState.research_task, "clean")
	if bool(robot.get("cleanup_target")):
		cue = "books" if GameState.research_task == "bookshelf" else ("bedding" if GameState.research_task == "bed" else "clean")
	if GameState.research_task == "sink" and GameState.repairs["sink"] and GameState.sink_dirty_dishes:
		cue = "meal" if dish_audio_step % 2 == 0 else "clean"
		dish_audio_step += 1
	if cue == "books":
		cue = ["books", "books_alt", "books_third"][rng.randi_range(0, 2)]
	play_world(cue, robot.global_position, false, "robot_task")
	robot_wait = 1.4 if cue.begins_with("books") else 1.8


func _activity_state_changed() -> void:
	if not GameState.research_active and GameState.personal_activity.is_empty():
		var finished_work := activity == "research"
		stop_activity(false)
		if finished_work and is_instance_valid(judy):
			play_world("desk", judy.global_position)
	if not is_instance_valid(room):
		return
	for chore in ["bookshelf", "plant", "bed"]:
		var level: int = GameState.chore_mess[chore]
		if level > int(mess_snapshot.get(chore, level)):
			var fixture: String = {"bookshelf": "Bookshelf", "plant": "PlantPot", "bed": "Bed"}[chore]
			var cue: String = {"bookshelf": "book_fall", "plant": "drip", "bed": "bedding"}[chore]
			play_world(cue, room.get_node(fixture).global_position)
		mess_snapshot[chore] = level
	var stage := int(GameState.sink_water_elapsed / 8.0)
	if stage > water_stage and GameState.tap_running:
		play_world("drip", room.get_node("Sink").global_position)
	water_stage = stage
	if GameState.tap_running and not tap_was_running:
		play_world("fault", room.get_node("Sink").global_position)
	tap_was_running = GameState.tap_running


func fridge_access() -> void:
	if not _world_allowed():
		return
	play_world("fridge_open", room.get_node("Fridge").global_position)
	fridge_close_after = 3.0


func stop_activity(cancel_repair_feedback: bool = true) -> void:
	for key in ["typing", "typing_alt", "cube", "eating"]:
		if layers.has(key) and is_instance_valid(layers[key]):
			layers[key].call("stop_now")
	for voice in world_voices:
		if is_instance_valid(voice) and bool(voice.get_meta("activity", false)):
			voice.stop()
	activity = ""
	activity_wait = 0.0
	reel_next = ""
	if cancel_repair_feedback:
		repair_sound_left = 0.0
		for voice in ui_voices:
			if bool(voice.get_meta("activity", false)):
				voice.stop()


func begin_instant() -> void:
	suppress_depth += 1
	stop_activity()
	for voice in world_voices:
		voice.stop()
	for layer in layers.values():
		layer.call("stop_now")


func end_instant() -> void:
	suppress_depth = maxi(0, suppress_depth - 1)
	if is_instance_valid(robot):
		last_task_serial = int(robot.get("session_serial"))
	# Never replay a pile of events simulated in a single instant.
	mess_snapshot = GameState.chore_mess.duplicate()
	water_stage = int(GameState.sink_water_elapsed / 8.0)
	tap_was_running = GameState.tap_running
	robot_was_working = false


func play_world(cue: String, point: Vector2, for_activity: bool = false, owner: String = "") -> void:
	var cooldown_key := cue + ":" + owner
	if not _world_allowed() or GameState.time_category != "misc" or float(cooldowns.get(cooldown_key, 0.0)) > 0:
		return
	var spec: Array = CUES.get(cue, [])
	if cue == "swat" and rng.randf() < 0.5:
		spec = CUES["swat_alt"]
	if cue == "step":
		spec = ["step_%d" % rng.randi_range(0, 2), -15.0, 1.0, 0.0]
	if spec.is_empty():
		return
	spec = spec.duplicate()
	var category := "activity" if for_activity else owner
	var voices_in_category := 0
	for voice in world_voices:
		if voice.playing and str(voice.get_meta("owner", "")) == category:
			voices_in_category += 1
	if not category.is_empty() and voices_in_category >= 2:
		return
	var priority := 3 if cue in ["swat", "fault", "book_fall"] else 1
	var available: AudioStreamPlayer2D = null
	for voice in world_voices:
		if not voice.playing:
			available = voice
			break
		if priority > int(voice.get_meta("priority", 1)):
			available = voice
	if available == null:
		return
	available.stop()
	available.global_position = point
	_start_voice(available, spec, for_activity)
	available.set_meta("owner", category)
	available.set_meta("priority", priority)
	cooldowns[cooldown_key] = 0.24 if cue == "step" else (0.12 if cue.begins_with("laser") else (0.5 if cue == "swat" else 0.8))


func play_ui(cue: String = "click", completion: bool = false) -> void:
	if (ui_wait > 0 and cue == "hover" and not completion) or not CUES.has(cue) or suppress_depth > 0 or GameState.activity_skip_busy or SaveStore.loading:
		return
	if cue == "repair":
		# Current gameplay repairs are atomic; present a short physical tool
		# sequence without changing their cost, rewards or simulation timing.
		repair_sound_left = 4.2
		repair_sound_wait = 0.8
		repair_sound_step = 1
		cue = "clank"
	for voice in ui_voices:
		if not voice.playing:
			var spec: Array = CUES[cue].duplicate()
			_start_voice(voice, spec, cue in ["ratchet", "screwdriver", "clank"])
			ui_wait = 0.09 if cue == "hover" else 0.14
			return


func _update_repair_audio(delta: float) -> void:
	if repair_sound_left <= 0.0:
		return
	repair_sound_left = maxf(0.0, repair_sound_left - delta)
	repair_sound_wait -= delta
	if repair_sound_wait <= 0.0 and repair_sound_left > 0.0:
		play_ui("screwdriver" if repair_sound_step % 2 else "ratchet", true)
		repair_sound_step += 1
		repair_sound_wait = 1.6


func _start_voice(voice: Node, spec: Array, for_activity: bool) -> void:
	var source: AudioStream = streams.get(spec[0])
	if source == null:
		return
	voice.set("stream", source)
	voice.set("pitch_scale", rng.randf_range(0.98, 1.02))
	voice.set_meta("gain", float(spec[1]) + rng.randf_range(-1.0, 1.0))
	voice.set_meta("activity", for_activity)
	# Preserve the recorded attack. Prepared files end on the audio thread;
	# a render-frame timer could stop a short click before its first mix buffer.
	voice.set("volume_db", float(voice.get_meta("gain")))
	voice.call("play", float(spec[3]))


func play_music(stream: AudioStream) -> void:
	if music.stream == stream:
		if stream != null and not music.playing:
			music.play()
		return
	music.stop()
	music.stream = stream
	if stream == null:
		music.stop()
	else:
		music.play()


func _update_music(delta: float) -> void:
	# One persistent player: menus, Watch/6x/Skip and day changes never seek it.
	if not is_instance_valid(music) or music.stream == null:
		return
	# Scene-tree pause must not leave the global theme suspended or stopped.
	if music.stream_paused:
		music.stream_paused = false
	if not music.playing:
		music.play()
	var target_db := MUSIC_MENU_DB
	# A pending/failed campaign restore must never silence the main menu.
	var silent := false
	var scene: Node = get_tree().current_scene
	if is_instance_valid(scene) and scene.has_node("HUD"):
		var current_hud: Node = scene.get_node("HUD")
		silent = SaveStore.loading or bool(current_hud.get("transitioning"))
		var evening := clampf((GameState.time_minutes + GameState.clock_fraction + GameState.world_accumulator - 1020.0) / 180.0, 0, 1)
		target_db = MUSIC_GAME_DB - evening * 2.0
		if GameState.game_finished:
			target_db = -8.0 if current_hud.get("ending_kind") == "good" else (-10.0 if current_hud.get("ending_kind") == "bittersweet" else -11.0)
		elif get_tree().paused:
			target_db = -13.0 if current_hud.call("_pause_open") else -11.0
		if current_hud.get("dialogue_overlay") != null and current_hud.get("dialogue_overlay").visible:
			target_db = minf(target_db, -12.0)
	var target := 0.0 if silent else db_to_linear(target_db)
	music_gain = lerpf(music_gain, target, 1.0 - exp(-delta * (5.0 if silent else 1.8)))
	music.volume_db = linear_to_db(maxf(0.0001, music_gain))
