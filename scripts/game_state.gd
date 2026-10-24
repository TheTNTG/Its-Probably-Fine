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

var day := 1
var time_minutes := DAY_START
var research_progress := 0
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
const REPAIR_COSTS := {"sink": 20, "bookshelf": 20, "plant": 20, "bed": 15}
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
var research_gain := 0
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


func _ready() -> void:
	_select_research_chore()


func _process(delta: float) -> void:
	if get_tree().paused or household_busy or ending_day_pending or (notification_active and not research_active) or day_ended or game_finished:
		return
	if research_active:
		# Research compresses 120 game minutes into three real minutes. The
		# same authoritative world stepper owns time and every consequence.
		advance_research(delta * RESEARCH_MINUTES * research_playback_rate / WATCH_REAL_SECONDS)
	elif time_minutes < DAY_END:
		_advance_world(delta * game_seconds_per_real_second / 60.0)


func begin_research() -> bool:
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
	research_gain = 5 if tap_running else 10
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
	research_swat = mosquito_task and mosquito_level > 0 and world_elapsed >= float(chore_ready_at.get("swat", 0.0))
	if research_swat:
		selected = "sink" if sink_water_elapsed >= 8.0 else "plant"
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
	var cooldown_key := "swat" if research_swat else research_task
	chore_ready_at[cooldown_key] = world_elapsed + (float(CHORE_COOLDOWNS[research_task]) if succeeded else 15.0)
	research_next_chore = world_elapsed + 0.5
	if succeeded and not day_ended and not game_finished:
		if research_swat:
			swat_mosquitoes(false)
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
	research_progress = mini(100, research_progress + research_gain)
	state_changed.emit()
	action_feedback.emit("Research complete: +%d%%, %d min, %d session(s) left." % [research_gain, research_duration, work_sessions_remaining])
	if not day_ended:
		if work_sessions_remaining <= 2:
			story_event.emit("ambient_%d" % day)


func swat_mosquitoes(manual: bool) -> void:
	water_exposure = maxf(0.0, water_exposure - 60.0)
	mosquito_level = mini(3, int(water_exposure / 60.0))
	mosquito_task = false
	if manual:
		_advance_time(5)
	state_changed.emit()
	action_feedback.emit("Mosquitoes reduced. Remove standing water to keep them away.")
var bed_protected_until := 0
var bed_mischief_day := 0


func needs_cleanup(chore: String) -> bool:
	return int(chore_mess[chore]) > 0 or (chore == "sink" and (sink_water_elapsed >= 8.0 or tap_running))


func research_available() -> bool:
	return int(chore_mess["bookshelf"]) < 2 and has_research_time()


func research_session_minutes() -> float:
	return PENALIZED_RESEARCH_MINUTES if tap_running else RESEARCH_MINUTES


func has_research_time() -> bool:
	return DAY_END - time_minutes - clock_fraction - world_accumulator >= research_session_minutes()


func research_block_reason() -> String:
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
	_advance_time(CLEAN_COSTS[chore])
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


func _advance_time(minutes: int) -> void:
	_advance_world(minf(float(minutes), DAY_END - time_minutes - clock_fraction - world_accumulator))
	state_changed.emit()


func continue_day() -> void:
	if not day_ended or game_finished:
		return
	if day == LAST_DAY:
		game_finished = true
	else:
		day += 1
		time_minutes = DAY_START
		clock_fraction = 0.0
		world_accumulator = 0.0
		world_elapsed = 0.0
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
	if not repairs.has(chore) or repairs[chore] or day_ended or game_finished:
		return
	repairs[chore] = true
	tiptop_fixed = not repairs.values().has(false)
	notification_active = false
	var earned_bonus := proactive_fix_eligible
	proactive_fix_eligible = false
	if earned_bonus:
		research_progress = mini(research_progress + 10, 100)
	_advance_time(REPAIR_COSTS[chore])
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
	research_gain = 0
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
	research_progress = 0
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
