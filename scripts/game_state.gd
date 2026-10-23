extends Node

signal state_changed
signal malfunction_triggered(message: String)

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


func work() -> void:
	if day_ended or game_finished:
		return
	if work_sessions_remaining <= 0:
		return
	work_sessions_remaining -= 1
	research_progress = mini(research_progress + (5 if tap_running else 10), 100)
	_advance_time(40 if tap_running else 30)
	if not day_ended:
		_check_malfunction()


func _advance_time(minutes: int) -> void:
	time_minutes = mini(time_minutes + minutes, DAY_END)
	if time_minutes >= DAY_END:
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
		if not tiptop_fixed:
			first_work_done = false
			_check_malfunction()
	state_changed.emit()


func end_day() -> void:
	if day_ended or game_finished:
		return
	if not tiptop_fixed and not end_day_reminded:
		end_day_reminded = true
		ending_day_pending = true
		notification_active = true
		malfunction_triggered.emit("TipTop's routine is still faulty. Fix before resting?")
		state_changed.emit()
		return
	ending_day_pending = false
	_advance_time(DAY_END - time_minutes)


func _check_malfunction() -> void:
	if tiptop_fixed or notification_active or first_work_done:
		return
	first_work_done = true
	tap_running = true
	notification_active = true
	malfunction_triggered.emit("TipTop left the tap running!" if day == 1 else "TipTop left the tap running... again!")
	state_changed.emit()


func fix_tap() -> void:
	if day_ended or game_finished or tiptop_fixed:
		return
	tap_running = false
	tiptop_fixed = true
	notification_active = false
	_advance_time(30)
	if ending_day_pending:
		end_day()


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


func restart() -> void:
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


func get_time_string() -> String:
	var hours := time_minutes / 60
	var mins := time_minutes % 60
	return "%02d:%02d" % [hours, mins]
