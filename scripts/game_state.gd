extends Node

signal state_changed
signal malfunction_triggered(message: String)
signal story_event(event: String)
signal repair_menu_requested
signal action_feedback(message: String)

const DAY_START := 660
const DAY_END := 1200
const DAY_LENGTH := DAY_END - DAY_START
const LAST_DAY := 3
const DAILY_WORK_SESSIONS := 4
const RESEARCH_MINUTES := 120.0
const PENALIZED_RESEARCH_MINUTES := 160.0
const WATCH_REAL_SECONDS := 180.0
const GOOD_ENDING_RESEARCH_THRESHOLD := 75.0
const DIFFICULTIES := [
	{"name": "Easy", "research": 15.0, "repair_reward": 5.0, "repair_minutes": 45, "work_mood": 15.0, "depletion": 0.70, "description": "More research, shorter repairs, gentler needs."},
	{"name": "Medium", "research": 10.0, "repair_reward": 4.0, "repair_minutes": 60, "work_mood": 20.0, "depletion": 1.00, "description": "The established balance, with repair rewards."},
	{"name": "Hard", "research": 8.0, "repair_reward": 3.0, "repair_minutes": 60, "work_mood": 25.0, "depletion": 1.20, "description": "Less research and faster needs depletion."}
]
var difficulty := 1
var difficulty_locked := false
const TIME_CATEGORIES := ["research", "eating", "leisure", "repairs", "cleanup", "misc"]
var daily_time := {"research": 0.0, "eating": 0.0, "leisure": 0.0, "repairs": 0.0, "cleanup": 0.0, "misc": 0.0}
var daily_time_history: Dictionary = {}
var time_category := "misc"
var repair_in_progress := false


func profile() -> Dictionary:
	return DIFFICULTIES[difficulty]


func select_difficulty(index: int) -> void:
	if not difficulty_locked:
		difficulty = clampi(index, 0, 2)


func repair_minutes() -> int:
	return int(profile()["repair_minutes"])


func preview_research_gain() -> float:
	return float(profile()["research"]) * (0.5 if tap_running else 1.0) * research_efficiency()


func displayed_daily_time() -> Dictionary:
	var totals := daily_time.duplicate()
	var category := current_time_category()
	totals[category] += world_accumulator
	return totals


func current_time_category() -> String:
	if research_active:
		return "research"
	if not personal_activity.is_empty():
		return "eating" if personal_activity == "eat" else "leisure"
	return time_category

var day := 1
var time_minutes := DAY_START
var research_progress := 0.0
var work_sessions_remaining := DAILY_WORK_SESSIONS
var tap_running := false
var tiptop_fixed := false
var unresolved_problem_count := 0
var notification_active := false
var first_work_done := false
var day_ended := false
var game_finished := false
var end_day_reminded := false
var ending_day_pending := false
var proactive_fix_eligible := true
const REPAIR_ROUTINES := ["sink", "plant", "bookshelf", "bed"]
const CLEAN_COSTS := {"sink": 15, "plant": 10, "bookshelf": 20, "bed": 5}
var repairs := {"sink": false, "bookshelf": false, "plant": false, "bed": false}
var chore_repetitions := {"plant": 0, "sink": 0, "bookshelf": 0, "bed": 0}
var chore_mess := {"plant": 0, "sink": 0, "bookshelf": 0, "bed": 1}
var sink_water_elapsed := 0.0
var household_busy := false
var water_exposure := 0.0
var mosquito_level := 0
var mosquito_task := false
var research_active := false
var research_playback_rate := 1.0
var research_duration := 0.0
var research_elapsed := 0.0
var research_gain := 0.0
var research_accumulator := 0.0
var research_task := "plant"
var research_task_serial := 0
var research_swat := false
var research_interruptions := 0
# One simulation accumulator for idle play, timed actions, Watch and Skip.
@export var game_seconds_per_real_second := 10.0
const WORLD_STEP := 0.25
var clock_fraction := 0.0
var world_accumulator := 0.0
var world_elapsed := 0.0
var research_next_chore := 3.0
var chore_cursor := 0
var robot_chore_resolved := false
const CHORE_COOLDOWNS := {"sink": 6.0, "plant": 12.0, "bookshelf": 9.0, "bed": 18.0}
var chore_ready_at: Dictionary = {}
var last_robot_chore := ""
var hunger := 85.0 # Fullness: higher means better fed.
var mood := 90.0
var work_streak := 0
var break_reminded := false
var break_reminder_count := 0
var response_counts: Dictionary = {}
const PERSONAL_ACTIVITIES := {"eat": [30, 40], "reels": [15, 18], "games": [30, 30], "cube": [20, 25]}
var personal_activity := ""
var personal_remaining := 0.0
var personal_playback_rate := 1.0
var overnight_day := 0
var mosquitoes: Dictionary = {}
var next_mosquito_id := 0
var mosquito_target_id := -1
var mosquito_spawn_after := 0.0
var last_robot_swat := false
var activity_skip_busy := false


func hunger_status() -> String:
	return "Well-fed" if hunger >= 75 else ("Normal" if hunger > 45 else "Hungry")


func _update_mosquito_population() -> void:
	var desired := mosquito_level * 2
	# Exposure controls spawning; lowering it must not remotely kill other flies.
	if mosquitoes.size() >= desired or world_elapsed < mosquito_spawn_after:
		mosquito_level = int(ceil(mosquitoes.size() / 2.0))
		return
	var robot: Node = get_tree().current_scene.get_node("TipTop")
	if not robot.mapped:
		robot._map_obstacles()
	while mosquitoes.size() < desired:
		var id := next_mosquito_id
		next_mosquito_id += 1
		var fixture: Node2D = get_tree().current_scene.get_node("Sink" if id % 2 else "PlantPot")
		var cell: Vector2i = robot._open_cell(fixture.global_position + Vector2(-16, 9))
		mosquitoes[id] = {"position": Vector2(cell) * 8, "previous": Vector2(cell) * 8, "velocity": Vector2.ZERO, "turn": 0.0, "count": id, "direction": Vector2.RIGHT}
	mosquito_level = int(ceil(mosquitoes.size() / 2.0))


func _move_mosquitoes(seconds: float) -> void:
	if mosquitoes.is_empty():
		return
	var robot: Node = get_tree().current_scene.get_node("TipTop")
	if not robot.mapped:
		robot._map_obstacles()
	for id in mosquitoes:
		var fly: Dictionary = mosquitoes[id]
		fly["turn"] -= seconds
		if float(fly["turn"]) <= 0:
			fly["count"] += 1
			var count: int = fly["count"]
			fly["turn"] = 1.5 + fposmod(count * 0.73, 1.8)
			fly["direction"] = Vector2.ZERO if count % 5 == 0 else Vector2.from_angle(count * 2.399 + int(id))
		var velocity: Vector2 = fly["velocity"]
		velocity = velocity.lerp(Vector2(fly["direction"]) * 4.0, 1.0 - exp(-4 * seconds))
		var point: Vector2 = fly["position"] + velocity * seconds
		var cell := Vector2i((point / 8).round())
		if robot.grid.is_in_boundsv(cell) and not robot.grid.is_point_solid(cell):
			fly["position"] = point
		else:
			fly["direction"] = Vector2(fly["direction"]).rotated(1.8)
			velocity = Vector2.ZERO
		fly["velocity"] = velocity


func eliminate_mosquito(id: int, from_point: Vector2) -> bool:
	if not mosquitoes.has(id) or from_point.distance_to(mosquitoes[id]["position"]) > 9.0:
		return false
	mosquitoes.erase(id)
	water_exposure = maxf(0, water_exposure - 30)
	mosquito_level = int(ceil(mosquitoes.size() / 2.0))
	mosquito_spawn_after = world_elapsed + 10.0
	return true


func reset_needs() -> void:
	hunger = 85.0
	mood = 90.0
	work_streak = 0
	break_reminded = false
	personal_activity = ""
	personal_remaining = 0.0
	personal_playback_rate = 1.0


func apply_overnight_needs() -> void:
	if overnight_day == day:
		return
	overnight_day = day
	var overnight_loss := 10.0 if mood >= 45 else 15.0
	# Mood is based on bedtime fullness BEFORE the overnight deduction.
	mood = 90.0 if hunger >= 70 else (80.0 if hunger >= 40 else (65.0 if hunger >= 20 else 40.0))
	hunger = maxf(0, hunger - overnight_loss)
	work_streak = 0
	break_reminded = false


func hunger_efficiency() -> float:
	return 1.0 if hunger >= 60 else (0.9 if hunger >= 30 else (0.75 if hunger > 0 else 0.6))


func pushing_through() -> bool:
	return mood < 45 and day == 3 and time_minutes >= 840


func mood_allows_research() -> bool:
	return mood >= 45 or pushing_through()


func research_efficiency() -> float:
	return hunger_efficiency() * (0.8 if pushing_through() else 1.0)


func start_personal_activity(activity: String) -> bool:
	if not PERSONAL_ACTIVITIES.has(activity) or not personal_activity.is_empty() or research_active or household_busy or notification_active or day_ended or game_finished:
		return false
	var minutes: int = PERSONAL_ACTIVITIES[activity][0]
	if DAY_END - time_minutes - clock_fraction - world_accumulator < minutes:
		action_feedback.emit("Not enough time before 8:00 PM for that activity.")
		return false
	if world_accumulator > 0:
		var pending := world_accumulator
		world_accumulator = 0.0
		_simulate_world_step(pending)
	personal_activity = activity
	personal_remaining = minutes
	personal_playback_rate = 1.0
	return true


func judy_response(context: String) -> String:
	var tier := 0 if mood >= 70 else (1 if mood >= 45 else 2)
	var pools := {
		"talk": [["How's my favorite household genius?", "How's the extremely important robot business?"], ["How are the chores going, TipTop?", "Give me the short version, buddy."], ["TipTop, please. I need a quiet minute.", "I'm listening. Just a little slowly today."]],
		"chore": [["Actual water. Bold interpretation, buddy.", "Well, the floor certainly looks hydrated."], ["That's actual water, TipTop. I'll handle it.", "The routine needs a correction. I'll sort it."], ["That's water, TipTop. Please stop the tap.", "Right. The tap again. Give me a minute."]],
		"break": [["Four hours? Science really needs a snooze button.", "Okay, you've caught me. I'll take a breather."], ["You're right. I should take a break.", "Let me step away from the notes for a bit."], ["Yeah. I'm running on fumes here.", "I know, buddy. I really need a minute."]]
	}
	var key := "%s:%d" % [context, tier]
	var index := int(response_counts.get(key, 0))
	response_counts[key] = index + 1
	var pool: Array = pools[context][tier]
	return pool[index % pool.size()]


func _ready() -> void:
	_select_research_chore()


func _process(delta: float) -> void:
	if get_tree().paused or household_busy or ending_day_pending or (notification_active and not research_active and personal_activity.is_empty()) or day_ended or game_finished:
		return
	if not personal_activity.is_empty():
		var step := minf(personal_remaining, delta * RESEARCH_MINUTES * personal_playback_rate / WATCH_REAL_SECONDS)
		advance_personal_activity(step)
	elif research_active:
		# Research compresses 120 game minutes into three real minutes. The
		# same authoritative world stepper owns time and every consequence.
		advance_research(delta * RESEARCH_MINUTES * research_playback_rate / WATCH_REAL_SECONDS)
	elif time_minutes < DAY_END:
		_advance_world(delta * game_seconds_per_real_second / 60.0)


func advance_personal_activity(minutes: float) -> void:
	if personal_activity.is_empty():
		return
	var remaining := minf(personal_remaining, maxf(0, minutes))
	_advance_world(remaining)
	personal_remaining = maxf(0, personal_remaining - remaining)
	if personal_remaining > 0.000001:
		return
	if world_accumulator > 0:
		var pending := world_accumulator
		world_accumulator = 0.0
		_simulate_world_step(pending)
	var activity := personal_activity
	personal_activity = ""
	personal_playback_rate = 1.0
	if activity == "eat":
		hunger = clampf(hunger + 40, 0, 100)
	else:
		mood = clampf(mood + float(PERSONAL_ACTIVITIES[activity][1]), 0, 100)
		work_streak = 0
		break_reminded = false
	action_feedback.emit("Meal finished: +40 Hunger." if activity == "eat" else "Break finished. Feeling more like myself.")
	state_changed.emit()


func skip_personal_activity() -> void:
	if activity_skip_busy or personal_activity.is_empty() or get_tree().paused:
		return
	activity_skip_busy = true
	advance_personal_activity(personal_remaining)
	for id in mosquitoes:
		mosquitoes[id]["previous"] = mosquitoes[id]["position"]
	get_tree().current_scene.get_node("Floor").reset_mosquito_visuals()
	activity_skip_busy = false


func begin_research() -> bool:
	if not personal_activity.is_empty():
		return false
	if research_active or notification_active or ending_day_pending or day_ended or game_finished or work_sessions_remaining <= 0 or not research_available():
		if not research_active and not day_ended and not game_finished and not research_available():
			action_feedback.emit(research_block_reason())
		return false
	# Commit pre-session idle time separately; it must not count as research.
	var pending_idle := world_accumulator
	world_accumulator = 0.0
	if pending_idle > 0.0:
		_simulate_world_step(pending_idle)
	if not research_available():
		action_feedback.emit(research_block_reason())
		return false
	research_active = true
	research_duration = research_session_minutes()
	# Snapshot needs at the start for identical playback rewards; retain fractions.
	research_gain = preview_research_gain()
	if pushing_through():
		action_feedback.emit("Judy is pushing through exhaustion: an extra 20% research penalty.")
	research_elapsed = 0.0
	research_accumulator = world_accumulator
	research_interruptions = 0
	work_sessions_remaining -= 1
	proactive_fix_eligible = false
	state_changed.emit()
	return true


func _select_research_chore() -> void:
	var chores := ["plant", "sink", "bookshelf", "bed"]
	var selected := ""
	# Cleanup takes priority, but a failed route keeps its retry cooldown.
	for chore in ["bookshelf", "bed", "sink", "plant"]:
		if repairs[chore] and needs_cleanup(chore) and world_elapsed >= float(chore_ready_at.get(chore, 0.0)):
			selected = chore
			break
	# Repair changes the outcome, never eligibility. Rotate all four routines
	# and avoid immediate repeats while another fixture is ready.
	if selected.is_empty():
		for pass_index in range(2):
			for offset in range(chores.size()):
				var index := (chore_cursor + offset) % chores.size()
				var chore: String = chores[index]
				if world_elapsed < float(chore_ready_at.get(chore, 0.0)) or (pass_index == 0 and chore == last_robot_chore):
					continue
				selected = chore
				chore_cursor = (index + 1) % chores.size()
				break
			if not selected.is_empty():
				break
	research_swat = not mosquitoes.is_empty() and (mosquito_task or not last_robot_swat) and world_elapsed >= float(chore_ready_at.get("swat", 0.0))
	if research_swat:
		selected = "sink" # Existing task slot; destination is the actual insect.
		mosquito_target_id = int(mosquitoes.keys()[research_task_serial % mosquitoes.size()])
	if selected != research_task or not selected.is_empty():
		research_task_serial += 1
	research_task = selected
	robot_chore_resolved = false


func resolve_robot_chore(serial: int, succeeded: bool) -> void:
	# Only the robot's completed physical action can produce chore effects.
	if serial != research_task_serial or robot_chore_resolved or research_task.is_empty():
		return
	robot_chore_resolved = true
	last_robot_chore = research_task
	last_robot_swat = research_swat
	var cooldown_key := "swat" if research_swat else research_task
	chore_ready_at[cooldown_key] = world_elapsed + ((8.0 if research_swat else float(CHORE_COOLDOWNS[research_task])) if succeeded else 15.0)
	research_next_chore = world_elapsed + 0.5
	if succeeded and not day_ended and not game_finished:
		if research_swat:
			mosquito_task = false # The robot already confirmed a nearby removal.
		else:
			finish_household_chore(research_task, true)
	state_changed.emit()


func advance_research(minutes: float) -> void:
	if not research_active:
		return
	var remaining := maxf(0.0, research_duration - research_elapsed - world_accumulator)
	_advance_world(minf(minutes, remaining))
	research_accumulator = world_accumulator


func _advance_world(minutes: float) -> void:
	world_accumulator += maxf(0.0, minutes)
	while time_minutes < DAY_END:
		var step := minf(WORLD_STEP, DAY_END - time_minutes - clock_fraction)
		if world_accumulator + 0.000001 < step:
			break
		world_accumulator = maxf(0.0, world_accumulator - step)
		_simulate_world_step(step)
	if time_minutes >= DAY_END:
		world_accumulator = 0.0


func _simulate_world_step(minutes: float) -> void:
	daily_time[current_time_category()] += minutes
	var depletion: float = profile()["depletion"]
	hunger = clampf(hunger - minutes * 7.0 * depletion / 60.0, 0, 100)
	mood = clampf(mood - minutes * 2.0 * depletion / 60.0, 0, 100)
	# Clock-driven water/exposure share chronological steps at every speed.
	# Robot chore outcomes additionally require physical action completion.
	world_elapsed += minutes
	clock_fraction += minutes
	var whole_minutes := int(floor(clock_fraction + 0.0000001))
	if whole_minutes > 0:
		time_minutes = mini(DAY_END, time_minutes + whole_minutes)
		clock_fraction = maxf(0.0, clock_fraction - whole_minutes)
	if tap_running:
		sink_water_elapsed = minf(31.0, sink_water_elapsed + minutes * 6.0)
	if sink_water_elapsed >= 8.0 or int(chore_mess["plant"]) > 0:
		water_exposure = minf(210.0, water_exposure + minutes)
	else:
		water_exposure = maxf(0.0, water_exposure - minutes * 2.0)
	mosquito_level = mini(3, int(water_exposure / 60.0))
	_update_mosquito_population()
	for id in mosquitoes:
		mosquitoes[id]["previous"] = mosquitoes[id]["position"]
	var robot: Node = get_tree().current_scene.get_node("TipTop")
	var seconds: float = minutes * (WATCH_REAL_SECONDS / RESEARCH_MINUTES if research_active or not personal_activity.is_empty() else 60.0 / game_seconds_per_real_second)
	# Activities share bounded logical AI substeps across Watch, 6x and instant
	# Skip. These are swept motion updates, not engine physics-frame simulation.
	while seconds > 0.000001:
		var tick := minf(0.05, seconds)
		_move_mosquitoes(tick)
		if not personal_activity.is_empty():
			robot.advance_activity_ai(tick)
		seconds -= tick
	if world_elapsed >= research_next_chore and (robot_chore_resolved or research_task.is_empty()):
		# Poll briefly during rest; cooldowns use the same authoritative clock.
		research_next_chore = world_elapsed + 0.5
		_select_research_chore()
	if research_active:
		research_elapsed = minf(research_duration, research_elapsed + minutes)
		if int(round(research_elapsed * 4)) % 20 == 0 and mosquito_level > 0:
			research_interruptions += 1
	if time_minutes >= DAY_END and int(chore_mess["bed"]) == 0:
		day_ended = true
		notification_active = false
	state_changed.emit()


func complete_research() -> void:
	if not research_active or research_elapsed < research_duration:
		return
	research_active = false
	research_playback_rate = 1.0
	research_progress = minf(100, research_progress + research_gain)
	mood = clampf(mood - float(profile()["work_mood"]), 0, 100)
	work_streak += 1
	if work_streak >= 2 and not break_reminded:
		break_reminded = true
		break_reminder_count += 1
		story_event.emit("break_reminder_%d_%d" % [day, break_reminder_count])
	state_changed.emit()
	action_feedback.emit("Research complete: +%.1f%%, %d min, %d session(s) left." % [research_gain, research_duration, work_sessions_remaining])
	if not day_ended:
		if work_sessions_remaining <= 2:
			story_event.emit("ambient_%d" % day)


func swat_mosquitoes(manual: bool) -> void:
	water_exposure = maxf(0.0, water_exposure - 60.0)
	mosquito_level = mini(3, int(water_exposure / 60.0))
	mosquito_task = false
	for index in range(mini(2, mosquitoes.size())):
		mosquitoes.erase(mosquitoes.keys()[0])
	mosquito_spawn_after = world_elapsed + 10.0
	_update_mosquito_population()
	if manual:
		_advance_time(5)
	state_changed.emit()
	action_feedback.emit("Mosquitoes reduced. Remove standing water to keep them away.")
var bed_protected_until := 0
var bed_mischief_day := 0


func needs_cleanup(chore: String) -> bool:
	return int(chore_mess[chore]) > 0 or (chore == "sink" and (sink_water_elapsed >= 8.0 or tap_running))


func research_available() -> bool:
	return int(chore_mess["bookshelf"]) < 2 and has_research_time() and mood_allows_research()


func research_session_minutes() -> float:
	return PENALIZED_RESEARCH_MINUTES if tap_running else RESEARCH_MINUTES


func has_research_time() -> bool:
	return DAY_END - time_minutes - clock_fraction - world_accumulator >= research_session_minutes()


func research_block_reason() -> String:
	if not mood_allows_research():
		return "Judy needs a break. Restore Mood to at least 45% before researching."
	if not has_research_time():
		return "Not enough time before 8:00 PM. A full research session needs %d minutes; no session used." % research_session_minutes()
	return "Research materials are misplaced. Organize the bookshelf (20 min)."


func clear_mess(chore: String) -> void:
	chore_mess[chore] = 0
	chore_repetitions[chore] = 0
	if chore == "sink":
		sink_water_elapsed = 0.0
	if chore == "bed":
		bed_protected_until = (day - 1) * DAY_LENGTH + time_minutes + 90
	state_changed.emit()


func manual_clean(chore: String) -> bool:
	if day_ended or game_finished or not needs_cleanup(chore):
		return false
	if chore == "sink" and tap_running:
		action_feedback.emit("Turn off the tap before mopping.")
		return false
	_advance_time(CLEAN_COSTS[chore], "cleanup")
	clear_mess(chore)
	action_feedback.emit("%s tidied. Routine unchanged. (-%d min)" % [chore.capitalize(), CLEAN_COSTS[chore]])
	return true


func finish_household_chore(chore: String, scheduled := false) -> void:
	if day_ended or game_finished or (household_busy and not scheduled) or not chore_mess.has(chore):
		return
	if repairs[chore]:
		if needs_cleanup(chore):
			clear_mess(chore)
	else:
		if chore == "bed":
			if time_minutes < DAY_END and bed_mischief_day != day and (day - 1) * DAY_LENGTH + time_minutes >= bed_protected_until:
				chore_mess["bed"] = 1
				bed_mischief_day = day
			state_changed.emit()
			return
		chore_repetitions[chore] += 1
		if chore_repetitions[chore] >= 2 and int(chore_mess[chore]) == 0:
			# One active mess per fixture until cleanup. Books still reach the
			# existing blocking threshold; plant mess retains drooping foliage.
			chore_mess[chore] = 2 if chore in ["bookshelf", "plant"] else 1
		# Use the same tap state as desk work and manual shutoff.
		if chore == "sink":
			tap_running = true
			_check_malfunction()
	state_changed.emit()


func work() -> void:
	if begin_research():
		advance_research(research_duration)
		complete_research()


func _advance_time(minutes: int, category: String = "misc") -> void:
	# Pending walking/idle time belongs to its original category.
	if world_accumulator > 0:
		var pending := world_accumulator
		world_accumulator = 0.0
		_simulate_world_step(pending)
	time_category = category
	_advance_world(minf(float(minutes), DAY_END - time_minutes - clock_fraction - world_accumulator))
	if world_accumulator > 0:
		var residual := world_accumulator
		world_accumulator = 0.0
		_simulate_world_step(residual)
	time_category = "misc"
	state_changed.emit()


func continue_day() -> void:
	if not day_ended or game_finished:
		return
	if day == LAST_DAY:
		game_finished = true
	else:
		apply_overnight_needs()
		daily_time_history[day] = daily_time.duplicate()
		for category in TIME_CATEGORIES:
			daily_time[category] = 0.0
		day += 1
		time_minutes = DAY_START
		clock_fraction = 0.0
		world_accumulator = 0.0
		world_elapsed = 0.0
		mosquito_spawn_after = 0.0
		research_next_chore = 3.0
		chore_cursor = 0
		chore_ready_at.clear()
		last_robot_chore = ""
		work_sessions_remaining = DAILY_WORK_SESSIONS
		day_ended = false
		end_day_reminded = false
		ending_day_pending = false
		chore_mess["bed"] = 1
		if not repairs["sink"]:
			first_work_done = false
		_select_research_chore()
	state_changed.emit()
	story_event.emit("ending" if game_finished else "day_%d" % day)


func end_day() -> void:
	if day_ended or game_finished:
		return
	if int(chore_mess["bed"]) > 0:
		action_feedback.emit("Make the bed first (E, 5 min), or let the repaired bed routine handle it.")
		return
	if not tiptop_fixed and not end_day_reminded:
		end_day_reminded = true
		ending_day_pending = true
		notification_active = true
		malfunction_triggered.emit("TipTop still has faulty routines. Repair before resting?")
		state_changed.emit()
		return
	ending_day_pending = false
	# Rest ends active simulation; do not run a whole evening of chores in bed.
	if world_accumulator > 0:
		var pending := world_accumulator
		world_accumulator = 0.0
		_simulate_world_step(pending)
	time_minutes = DAY_END
	clock_fraction = 0.0
	world_accumulator = 0.0
	day_ended = true
	notification_active = false
	state_changed.emit()


func _check_malfunction() -> void:
	if repairs["sink"] or notification_active or first_work_done:
		return
	first_work_done = true
	tap_running = true
	notification_active = true
	malfunction_triggered.emit("TipTop left the tap running!" if day == 1 else "TipTop left the tap running... again!")
	state_changed.emit()
	if day == 1:
		story_event.emit("first_tap")


func fix_tap() -> void:
	if day_ended or game_finished or household_busy:
		return
	repair_menu_requested.emit()


func repair_routine(chore: String) -> void:
	if repair_in_progress or not repairs.has(chore) or repairs[chore] or day_ended or game_finished:
		return
	var duration := repair_minutes()
	if DAY_END - time_minutes - clock_fraction - world_accumulator < duration:
		action_feedback.emit("A full repair needs %d minutes before 8:00 PM. No time or reward charged." % duration)
		return
	repair_in_progress = true
	_advance_time(duration, "repairs")
	repairs[chore] = true
	tiptop_fixed = not repairs.values().has(false)
	notification_active = false
	if chore == "sink":
		tap_running = false
	var earned_bonus := proactive_fix_eligible
	proactive_fix_eligible = false
	var reward: float = profile()["repair_reward"]
	research_progress = minf(100, research_progress + reward)
	if earned_bonus:
		research_progress = minf(research_progress + 10, 100)
	repair_in_progress = false
	state_changed.emit()
	action_feedback.emit("%s routine repaired: +%.0f%% research. (-%d min)" % [chore.capitalize(), reward, duration])
	if ending_day_pending:
		end_day()
	if chore == "sink":
		story_event.emit("fixed")
	else:
		action_feedback.emit("TipTop: %s routine updated. Thank you, Judy!" % chore.capitalize())
	if earned_bonus:
		story_event.emit("proactive_fix")


func turn_off_tap() -> void:
	if day_ended or game_finished or not tap_running:
		return
	tap_running = false
	notification_active = false
	state_changed.emit()


func ignore_tap() -> void:
	if day_ended or game_finished or not notification_active:
		return
	unresolved_problem_count += 1
	notification_active = false
	if ending_day_pending:
		end_day()
	state_changed.emit()
	story_event.emit("ignored_%d" % day)


func restart() -> void:
	difficulty = 1
	difficulty_locked = false
	time_category = "misc"
	repair_in_progress = false
	daily_time_history.clear()
	for category in TIME_CATEGORIES:
		daily_time[category] = 0.0
	reset_needs()
	overnight_day = 0
	mosquitoes.clear()
	next_mosquito_id = 0
	mosquito_spawn_after = 0.0
	mosquito_target_id = -1
	last_robot_swat = false
	break_reminder_count = 0
	response_counts.clear()
	chore_cursor = 0
	chore_ready_at.clear()
	last_robot_chore = ""
	clock_fraction = 0.0
	world_accumulator = 0.0
	world_elapsed = 0.0
	research_playback_rate = 1.0
	research_active = false
	research_elapsed = 0.0
	research_accumulator = 0.0
	research_task_serial = 0
	research_duration = 0
	research_gain = 0.0
	research_interruptions = 0
	research_next_chore = 3.0
	research_task = "plant"
	research_swat = false
	mosquito_task = false
	repairs = {"sink": false, "bookshelf": false, "plant": false, "bed": false}
	household_busy = false
	water_exposure = 0.0
	mosquito_level = 0
	bed_protected_until = 0
	bed_mischief_day = 0
	sink_water_elapsed = 0.0
	chore_repetitions = {"plant": 0, "sink": 0, "bookshelf": 0, "bed": 0}
	chore_mess = {"plant": 0, "sink": 0, "bookshelf": 0, "bed": 1}
	day = 1
	time_minutes = DAY_START
	research_progress = 0.0
	work_sessions_remaining = DAILY_WORK_SESSIONS
	tap_running = false
	tiptop_fixed = false
	unresolved_problem_count = 0
	notification_active = false
	first_work_done = false
	day_ended = false
	game_finished = false
	end_day_reminded = false
	ending_day_pending = false
	proactive_fix_eligible = true
	_select_research_chore()


func get_time_string() -> String:
	var hours := time_minutes / 60
	var mins := time_minutes % 60
	return "%02d:%02d" % [hours, mins]
