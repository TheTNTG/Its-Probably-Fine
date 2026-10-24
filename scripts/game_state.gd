extends Node

signal state_changed
signal malfunction_triggered(message: String)
signal story_event(event: String)
signal repair_menu_requested
signal action_feedback(message: String)

const DAY_START := 540
const DAY_END := 1080
const LAST_DAY := 3
const DAILY_WORK_SESSIONS := 4

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
var research_duration := 0
var research_elapsed := 0.0
var research_gain := 0
var research_accumulator := 0.0
var research_task := "plant"
var research_task_serial := 0
var research_swat := false
var research_interruptions := 0
var research_next_chore := 3.0


func begin_research() -> bool:
	if research_active or day_ended or game_finished or work_sessions_remaining <= 0 or not research_available():
		return false
	research_active = true
	research_duration = mini(40 if tap_running else 30, DAY_END - time_minutes)
	research_gain = 5 if tap_running else 10
	research_elapsed = 0.0
	research_accumulator = 0.0
	research_interruptions = 0
	research_next_chore = 3.0
	work_sessions_remaining -= 1
	proactive_fix_eligible = false
	_select_research_chore()
	state_changed.emit()
	return true


func _select_research_chore() -> void:
	var chores := ["plant", "sink", "bookshelf", "bed"]
	research_task = chores[(day + work_sessions_remaining + int(research_next_chore / 3.0)) % 4]
	for chore in ["bookshelf", "bed", "sink", "plant"]:
		if repairs[chore] and needs_cleanup(chore):
			research_task = chore
			break
	research_swat = mosquito_task and mosquito_level > 0
	if research_swat:
		research_task = "sink" if sink_water_elapsed >= 8.0 else "plant"
	research_task_serial += 1


func advance_research(minutes: float) -> void:
	if not research_active:
		return
	var previous_elapsed := research_elapsed
	research_accumulator += minutes
	# The same quarter-minute event stream is used at every playback speed.
	while research_accumulator >= 0.25 and research_elapsed < research_duration:
		research_accumulator -= 0.25
		research_elapsed += 0.25
		if tap_running:
			sink_water_elapsed = minf(31.0, sink_water_elapsed + 1.5)
		if int(round(research_elapsed * 4)) % 4 == 0:
			_advance_time(1)
		if research_elapsed == research_next_chore - 1.0 and research_task == "sink" and repairs["sink"]:
			# Shut off at the cleanup phase, before the scheduled mopping finishes.
			tap_running = false
		if research_elapsed >= research_next_chore:
			if research_swat:
				swat_mosquitoes(false)
			else:
				if research_task == "sink" and repairs["sink"]:
					tap_running = false
				finish_household_chore(research_task)
			research_next_chore += 3.0
			_select_research_chore()
			state_changed.emit()
		if int(round(research_elapsed * 4)) % 20 == 0 and mosquito_level > 0:
			research_interruptions += 1
			# A short visible swat; no extra research/time penalty.
	if research_elapsed != previous_elapsed:
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
		_check_malfunction()
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
	return int(chore_mess["bookshelf"]) < 2 and time_minutes < DAY_END


func clear_mess(chore: String) -> void:
	chore_mess[chore] = 0
	chore_repetitions[chore] = 0
	if chore == "sink":
		sink_water_elapsed = 0.0
	if chore == "bed":
		bed_protected_until = (day - 1) * 540 + time_minutes + 90
	state_changed.emit()


func manual_clean(chore: String) -> bool:
	if day_ended or game_finished or not needs_cleanup(chore):
		return false
	if chore == "sink" and tap_running:
		action_feedback.emit("Turn off the tap before mopping.")
		return false
	clear_mess(chore)
	_advance_time(CLEAN_COSTS[chore])
	action_feedback.emit("%s tidied. Routine unchanged. (-%d min)" % [chore.capitalize(), CLEAN_COSTS[chore]])
	return true


func finish_household_chore(chore: String) -> void:
	if day_ended or game_finished or household_busy or not chore_mess.has(chore):
		return
	if repairs[chore]:
		clear_mess(chore)
	else:
		if chore == "bed":
			if time_minutes < DAY_END and bed_mischief_day != day and (day - 1) * 540 + time_minutes >= bed_protected_until:
				chore_mess["bed"] = 1
				bed_mischief_day = day
			state_changed.emit()
			return
		chore_repetitions[chore] += 1
		if chore_repetitions[chore] >= 2:
			chore_mess[chore] = mini(3, int(chore_mess[chore]) + 1)
		# Use the same tap state as desk work and manual shutoff.
		if chore == "sink" and first_work_done:
			tap_running = true
	state_changed.emit()


func work() -> void:
	if begin_research():
		advance_research(research_duration)
		complete_research()


func _advance_time(minutes: int) -> void:
	var elapsed := mini(minutes, DAY_END - time_minutes)
	if sink_water_elapsed >= 8.0 or int(chore_mess["plant"]) > 0:
		water_exposure = minf(210.0, water_exposure + elapsed)
	else:
		water_exposure = maxf(0.0, water_exposure - elapsed * 2.0)
	mosquito_level = mini(3, int(water_exposure / 60.0))
	time_minutes = mini(time_minutes + minutes, DAY_END)
	if time_minutes >= DAY_END and int(chore_mess["bed"]) == 0:
		day_ended = true
		notification_active = false
	state_changed.emit()


func continue_day() -> void:
	if not day_ended or game_finished:
		return
	if day == LAST_DAY:
		game_finished = true
	else:
		day += 1
		time_minutes = DAY_START
		work_sessions_remaining = DAILY_WORK_SESSIONS
		day_ended = false
		end_day_reminded = false
		ending_day_pending = false
		chore_mess["bed"] = 1
		if not repairs["sink"]:
			first_work_done = false
			_check_malfunction()
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
	_advance_time(DAY_END - time_minutes)


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


func get_time_string() -> String:
	var hours := time_minutes / 60
	var mins := time_minutes % 60
	return "%02d:%02d" % [hours, mins]
