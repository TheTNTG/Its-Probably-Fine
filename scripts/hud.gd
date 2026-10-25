extends CanvasLayer

@onready var day_label: Label = $DayLabel
@onready var time_label: Label = $TimeLabel
@onready var research_label: Label = $ResearchLabel
@onready var notification_panel: Control = $NotificationPanel
@onready var notification_label: Label = $NotificationPanel/NotificationLabel
@onready var fix_button: Button = $NotificationPanel/FixButton
@onready var ignore_button: Button = $NotificationPanel/IgnoreButton

var loop_panel: ColorRect
var loop_message: Label
var loop_button: Button
var sessions_label: Label
var dialogue_overlay: ColorRect
var dialogue_speaker: Label
var dialogue_text: Label
var dialogue_lines: Array = []
var dialogue_art: TextureRect
var dialogue_portrait: TextureRect
var dialogue_portrait_frame: Control
var dialogue_accent: Polygon2D
var dialogue_plain: ColorRect
var portrait_tween: Tween
var portrait_cache: Dictionary = {}
var story_seen: Dictionary = {}
var pending_feedback: Array = []
var reveal_characters := 0.0
var last_portrait := ""
var dialogue_bounds := Vector2(150, 26)
var dialogue_hint: Label
var transitioning := false
var transition_cover: ColorRect
var transition_title: Label
var transition_events: Array[String] = []
var repair_panel: ColorRect
var repair_buttons: Dictionary = {}
var household_panel: ColorRect
var system_notice: ColorRect
var system_text: Label
var system_messages: Array[String] = []
var system_left := 0.0
var research_strip: ColorRect
var research_status: Label
var research_help: Label
var activity_buttons: Array[Button] = []
var active_dialogue_event := ""
var research_bar: ProgressBar
var research_speed_button: Button
var overview_bar: ProgressBar
var weekday_label: Label
var time_remaining: Label
var time_bar: ProgressBar
var time_bar_fill: StyleBoxFlat
var deferred_story_events: Array[String] = []
var dialogue_resume_loop := false
var morning_pending_day := 0
var sleep_dialogue_pending := false
var tiptop_talk_count := 0
var hunger_label: Label
var mood_label: Label
var hunger_bar: ProgressBar
var mood_bar: ProgressBar
var hunger_fill: StyleBoxFlat
var mood_fill: StyleBoxFlat
var efficiency_label: Label
var hunger_status_label: Label
var activity_watch_button: Button
const UI_REFERENCE := Vector2(432, 288)
const SIDEBAR_X := 332.0
var sidebar: VBoxContainer
var problem_rows: Dictionary = {}
var problem_count: Label
var usage_title: Label
var usage_rows: Dictionary = {}
var usage_segments: Dictionary = {}
var difficulty_controls: HBoxContainer
var difficulty_description: Label
var save_button: Button
var save_status: Label
var pause_panel: ColorRect
var eject_button: Button
var eject_confirm: ColorRect
var mood_hint: Label
var tutorial: Control
var tutorial_entry := false
var rules_intro: ColorRect
var rules_review := false
var rules_acknowledged := false
var showcase: Control
var ending_kind := ""
var deadline_label: Label
var deadline_bar: ProgressBar
var deadline_fill: StyleBoxFlat
var detail_controller: Node
var detail_panel: PanelContainer
var detail_buttons: Dictionary = {}
var detail_groups: Dictionary = {}
var detail_research: Label
var detail_needs: Label
var detail_repair_count: Label
var compact_warning: Label
var icon_label_gutter: Control
var research_modifiers: Dictionary = {}
var research_next: Label
var needs_values: Dictionary = {}
var needs_modifiers: Dictionary = {}
const TIME_COLORS := [Color("72a7be"), Color("e0b065"), Color("a78abd"), Color("83b6a2"), Color("bd947a"), Color("7f8595")]


func _household_open() -> bool:
	return is_instance_valid(household_panel) and household_panel.visible


func _pause_open() -> bool:
	return is_instance_valid(pause_panel) and pause_panel.visible


func _rules_open() -> bool:
	return is_instance_valid(rules_intro) and rules_intro.visible


func _comic_safe() -> bool:
	return not _rules_open() and not _pause_open() and not _eject_open() and not GameState.research_active and not get_node("../Player").animation_busy and not transitioning and not repair_panel.visible and not _household_open()


func overhead_thoughts_allowed() -> bool:
	return not _rules_open() and not _pause_open() and not _eject_open() and not dialogue_overlay.visible and not repair_panel.visible and not loop_panel.visible and not notification_panel.visible and not transitioning and not _household_open() and not GameState.day_ended and not GameState.game_finished


func _restore_modal_pause() -> void:
	get_tree().paused = _rules_open() or _pause_open() or _eject_open() or dialogue_overlay.visible or repair_panel.visible or loop_panel.visible or _household_open() or transitioning or GameState.day_ended or GameState.game_finished


func research_choices() -> void:
	if GameState.research_active or get_node("../Player").animation_busy:
		return
	if GameState.work_sessions_remaining <= 0:
		_show_feedback("Too exhausted to work. Rest until tomorrow.")
		return
	if not GameState.research_available():
		if GameState.fullness_allows_research() and GameState.has_research_time() and GameState.mood_allows_research() and int(GameState.chore_mess["bookshelf"]) >= 2:
			household_choices("bookshelf")
		else:
			_show_feedback(GameState.research_block_reason())
		return
	household_choices("research")


func _tiptop_nearby() -> bool:
	var judy = get_node("../Player")
	var robot: Node2D = get_node("../TipTop")
	return judy.global_position.distance_to(robot.global_position - Vector2(0, 7)) <= judy.INTERACTION_DISTANCE


func tiptop_interaction() -> void:
	if not _comic_safe() or dialogue_overlay.visible or loop_panel.visible or GameState.notification_active or not _tiptop_nearby():
		return
	if GameState.tiptop_fixed:
		talk_to_tiptop()
	else:
		household_choices("tiptop")


func talk_to_tiptop() -> void:
	if not _comic_safe() or dialogue_overlay.visible or loop_panel.visible or GameState.notification_active or not _tiptop_nearby():
		return
	var chore: String = GameState.research_task
	var work_comment := "I was checking the %s. It appreciates the attention." % ("bookshelf" if chore == "bookshelf" else chore)
	if chore.is_empty() or GameState.robot_chore_resolved:
		work_comment = "A brief pause between helpful activities. Very strategic."
	var pools := [
		[["Judy", "How's the extremely important robot business?", "happy"], ["TipTop", work_comment, "proud"], ["Judy", "Carry on, chief.", "happy"]],
		[["TipTop", "Research update requested!", "neutral"], ["Judy", "Mostly notes. Some of them even agree with each other.", "neutral"], ["TipTop", "An encouraging level of cooperation.", "proud"]],
		[["Judy", "You doing okay, buddy?", "neutral"], ["TipTop", "Yes! I am practically unstoppable. Except by furniture.", "proud"], ["Judy", "Yeah, furniture gets everyone eventually.", "happy"]],
		[["TipTop", "Are we ready for the showcase?", "worried"], ["Judy", "We've got results. Now I just have to explain them." if GameState.research_progress >= GameState.GOOD_ENDING_RESEARCH_THRESHOLD else "Getting there. My notes are starting to look suspiciously useful.", "happy"], ["TipTop", "I shall provide supportive hovering.", "proud"]]
	]
	# A direct conversation takes priority without dropping queued story lines.
	var selected_talk: Array = pools[tiptop_talk_count % pools.size()].duplicate(true)
	if tiptop_talk_count % pools.size() in [0, 2]:
		selected_talk[0].append("talk")
	dialogue_lines = selected_talk + dialogue_lines
	tiptop_talk_count += 1
	_advance_dialogue()


func set_research_controls(active: bool) -> void:
	research_strip.visible = active
	notification_panel.hide()
	if active:
		pending_feedback.clear()


func _set_activity_speed(rate: float) -> void:
	if get_tree().paused:
		return
	if not GameState.personal_activity.is_empty():
		GameState.personal_playback_rate = rate
	elif GameState.research_active:
		get_node("../Player").research_fast_forward = rate > 1
		GameState.research_playback_rate = rate


func _skip_research() -> void:
	if not get_tree().paused and not GameState.personal_activity.is_empty():
		GameState.skip_personal_activity()
		return
	if get_tree().paused or not GameState.research_active:
		return
	var remaining := GameState.research_duration - GameState.research_elapsed - GameState.research_accumulator
	if remaining > 0.0:
		# Preserve scheduled chores, messes and mosquitoes; the player animation
		# handles standing up and awarding the session exactly once afterward.
		ApartmentAudio.begin_instant()
		GameState.advance_research(remaining)
		ApartmentAudio.end_instant()


func household_choices(location: String) -> void:
	if is_instance_valid(household_panel) or transitioning or dialogue_overlay.visible or repair_panel.visible or loop_panel.visible or GameState.research_active or get_node("../Player").animation_busy or GameState.day_ended or GameState.game_finished:
		return
	get_node("../TipTop").clear_monologue()
	get_node("../TipTop").action_label.hide()
	var prior_pause := get_tree().paused
	get_tree().paused = true
	household_panel = ColorRect.new()
	household_panel.size = Vector2(384, 288)
	household_panel.color = Color(0.08, 0.08, 0.12, 0.98)
	add_child(household_panel)
	var center := CenterContainer.new()
	household_panel.add_child(center)
	center.set_anchors_and_offsets_preset(Control.PRESET_FULL_RECT)
	var choices := VBoxContainer.new()
	choices.add_theme_constant_override("separation", 4)
	center.add_child(choices)
	_fit_screen_ui()
	var options: Array = []
	var judy = get_node("../Player")
	if location == "research":
		_hud_text(choices, "Research", Vector2.ZERO, 10)
		_hud_text(choices, "Sessions: %d used · %d/%d left" % [GameState.DAILY_WORK_SESSIONS - GameState.work_sessions_remaining, GameState.work_sessions_remaining, GameState.DAILY_WORK_SESSIONS], Vector2.ZERO, 8)
		var efficiency := int(round(GameState.research_efficiency() * 100))
		_hud_text(choices, "Efficiency: %d%% | Reward: +%.1f%% research%s" % [efficiency, GameState.preview_research_gain(), " (pushing through)" if GameState.pushing_through() else ""], Vector2.ZERO, 7)
		var duration := GameState.research_session_minutes()
		var watch_minutes := duration / GameState.RESEARCH_MINUTES * GameState.WATCH_REAL_SECONDS / 60.0
		_hud_text(choices, "%s · %d game min · Watch ~%.1f real min" % [GameState.profile()["name"], duration, watch_minutes], Vector2.ZERO, 7)
		_hud_text(choices, "Ready to research" if GameState.research_available() else "Research unavailable", Vector2.ZERO, 7)
		options.append(["Watch Research", judy._research_animation.bind(false)])
		options.append(["Fast-forward · 6x", judy._research_animation.bind(true)])
	elif location == "break":
		_hud_text(choices, "Take a break", Vector2.ZERO, 9)
		options.append(["Watch reels — 15 min, +18 Mood", judy.personal_activity.bind("reels")])
		options.append(["Play phone games — 30 min, +30 Mood", judy.personal_activity.bind("games")])
		options.append(["Solve Rubik's cube — 20 min, +25 Mood", judy.personal_activity.bind("cube")])
	elif location == "fridge":
		options.append(["Eat at the coffee table — 30 min, +40 Fullness, +10 Mood", judy.personal_activity.bind("eat")])
	elif location == "bookshelf":
		options.append(["Organize books myself — 20 min", judy.organize_for_research])
	elif location == "tiptop":
		options.append(["Talk to TipTop", talk_to_tiptop])
		if not GameState.tiptop_fixed:
			options.append(["Repair TipTop...", GameState.fix_tap])
	elif GameState.needs_cleanup(location):
		options.append(["Clean %s myself — %d min" % [location, GameState.CLEAN_COSTS[location]], judy._clean_animation.bind(location)])
	if GameState.mosquito_level > 0 and location not in ["research", "break", "fridge"]:
		options.append(["Swat mosquitoes myself — 5 min", judy.swat_animation])
		options.append(["Ask TipTop to swat mosquitoes — free", _request_swatter])
	options.append(["Cancel", func(): pass])
	for index in range(options.size()):
		var button := Button.new()
		button.custom_minimum_size = Vector2(250, 22)
		button.size_flags_horizontal = Control.SIZE_EXPAND_FILL
		button.text = options[index][0]
		button.add_theme_font_size_override("font_size", 8)
		button.pressed.connect(_household_selected.bind(options[index][1], prior_pause))
		choices.add_child(button)


func _household_selected(action: Callable, prior_pause: bool) -> void:
	if not is_instance_valid(household_panel) or not household_panel.visible:
		return
	household_panel.hide()
	household_panel.queue_free()
	get_tree().paused = prior_pause
	action.call()


func _request_swatter() -> void:
	if GameState.mosquitoes.is_empty():
		_show_feedback("TipTop: No airborne intruders detected.")
		return
	GameState.request_mosquito_batch()
	_show_feedback("TipTop: Mosquito removal requested. On my way!")


func _ready() -> void:
	process_mode = Node.PROCESS_MODE_ALWAYS
	if get_tree().has_meta("tutorial_entry"):
		tutorial_entry = true
		get_tree().remove_meta("tutorial_entry")
	_build_loop_ui()
	_build_dialogue_ui()
	_build_transition_ui()
	_build_repair_menu()
	_build_system_notice()
	_build_research_controls()
	_build_needs_ui()
	_build_pause_menu()
	_build_eject_confirmation()
	rules_intro = ColorRect.new()
	rules_intro.set_script(preload("res://scripts/rules_intro.gd"))
	add_child(rules_intro)
	rules_intro.connect("dismissed", _rules_dismissed)
	_fit_screen_ui()
	get_viewport().size_changed.connect(_fit_screen_ui)
	_smooth_ui_text(self)
	preload("res://scripts/typography.gd").accent(day_label)
	preload("res://scripts/typography.gd").accent(transition_title)
	GameState.state_changed.connect(_update_hud)
	GameState.malfunction_triggered.connect(_show_malfunction)
	GameState.story_event.connect(_on_story_event)
	GameState.repair_menu_requested.connect(_open_repair_menu)
	GameState.action_feedback.connect(_show_feedback)
	GameState.meaningful_break_taken.connect(_clear_stale_break_reminders)
	_update_hud()
	tutorial = Control.new()
	tutorial.set_script(preload("res://scripts/tutorial.gd"))
	add_child(tutorial)
	if SaveStore.loading:
		loop_panel.hide()
		transition_cover.position = Vector2.ZERO
		transition_cover.show()
		transition_title.text = "Continuing..."
		transition_title.show()
		SaveStore.restore_room.call_deferred()
		return
	if get_tree().has_meta("restart_playing"):
		get_tree().remove_meta("restart_playing")
		loop_panel.hide()
		difficulty_controls.hide()
		difficulty_description.hide()
		if tutorial_entry:
			_on_loop_pressed.call_deferred()
		else:
			_show_campaign_rules.call_deferred()
	if get_tree().has_meta("new_game_slide"):
		get_tree().remove_meta("new_game_slide")
		_reveal_new_game()


func _fit_screen_ui() -> void:
	# Fit a reference canvas uniformly, retaining safe margins at any aspect ratio.
	var screen := get_viewport().get_visible_rect().size
	var reference := UI_REFERENCE
	var factor := minf(screen.x / reference.x, screen.y / reference.y)
	transform = Transform2D(0.0, Vector2(factor, factor), 0.0, (screen - reference * factor) * 0.5)
	# Reserve the sidebar in screen space; keep the whole apartment in the left pane.
	var camera: Camera2D = get_node("../FramingCamera")
	var outline: PackedVector2Array = PackedVector2Array(get_node("../Walls").ROOM_EDGE)
	var room_bounds := Rect2(outline[0], Vector2.ZERO)
	for point in outline:
		room_bounds = room_bounds.expand(point)
	# Include the five-unit wall caps, rather than fitting only the floor.
	room_bounds = room_bounds.grow(5.0)
	var left_wall_bottom := room_bounds.position.y
	for point in outline:
		if point.x <= room_bounds.position.x + 5.0:
			left_wall_bottom = maxf(left_wall_bottom, point.y + 5.0)
	# The recessed entrance can use the empty lower center. The left wing must
	# stop above the unchanged controls (y=242); the right edge clears the sidebar.
	var world_zoom := minf(1.08 * 1.20, (SIDEBAR_X - 20.0) / room_bounds.size.x)
	world_zoom = minf(world_zoom, (238.0 - 40.0) / (left_wall_bottom - room_bounds.position.y))
	world_zoom = minf(world_zoom, (UI_REFERENCE.y - 6.0 - 40.0) / room_bounds.size.y)
	var framed_center := Vector2((8.0 + SIDEBAR_X - 12.0) * 0.5, 40.0 + room_bounds.size.y * world_zoom * 0.5)
	camera.zoom = Vector2(factor, factor) * world_zoom
	camera.position = room_bounds.get_center() + (UI_REFERENCE * 0.5 - framed_center) / world_zoom
	(transition_cover.get_parent() as CanvasLayer).transform = transform
	if is_instance_valid(repair_panel):
		repair_panel.position = -transform.origin / factor
		repair_panel.size = screen / factor
	if is_instance_valid(household_panel):
		# Include any aspect-ratio margins in the dimmer; center its contents
		# against the visible screen, independently of the camera.
		household_panel.position = -transform.origin / factor
		household_panel.size = screen / factor
	if is_instance_valid(eject_confirm):
		eject_confirm.position = -transform.origin / factor
		eject_confirm.size = screen / factor
	if is_instance_valid(pause_panel):
		pause_panel.position = -transform.origin / factor
		pause_panel.size = screen / factor
	if is_instance_valid(rules_intro):
		rules_intro.position = -transform.origin / factor
		rules_intro.size = screen / factor


func _smooth_ui_text(node: Node) -> void:
	if node is Control:
		node.texture_filter = CanvasItem.TEXTURE_FILTER_NEAREST if (node.has_meta("dialogue_pixel_art") or node.has_meta("pixel_icon")) else CanvasItem.TEXTURE_FILTER_LINEAR
	for child in node.get_children():
		_smooth_ui_text(child)


func _update_clock_hud() -> void:
	var current := clampf(GameState.time_minutes + GameState.clock_fraction + GameState.world_accumulator, GameState.DAY_START, GameState.DAY_END)
	var whole_minutes := int(floor(current))
	var hour := int(whole_minutes / 60)
	time_label.text = "%d:%02d %s" % [posmod(hour - 1, 12) + 1, whole_minutes % 60, "AM" if hour < 12 else "PM"]
	var left := maxi(0, int(ceil(GameState.DAY_END - current)))
	time_remaining.text = "%dh %02dm left" % [int(left / 60), left % 60]
	var fraction := (GameState.DAY_END - current) / float(GameState.DAY_END - GameState.DAY_START)
	time_bar.value = fraction * 100.0
	time_bar_fill.bg_color = Color("d87369") if fraction < 0.15 else (Color("df9e48") if fraction < 0.40 else Color("e1bd70"))
	# Remaining playable time: future nine-hour days plus today's remainder.
	# Overnight hours are deliberately absent; pending clock fractions are shared.
	var total := float(GameState.LAST_DAY * GameState.DAY_LENGTH)
	var remaining := clampf((GameState.LAST_DAY - GameState.day) * GameState.DAY_LENGTH + GameState.DAY_END - current, 0, total)
	var minutes := int(ceil(remaining - 0.000001))
	deadline_label.text = "Showcase in\n%dh %02dm playable" % [minutes / 60, minutes % 60]
	deadline_bar.value = remaining / total * 100.0
	deadline_fill.bg_color = _muted_gradient(remaining / total, [0.0, 0.10, 0.25, 0.5, 1.0], [Color("aa625c"), Color("aa625c"), Color("c28764"), Color("c6a367"), Color("86a795")])
	deadline_label.modulate = Color("dca69a") if remaining <= 60 else Color.WHITE


func _update_hud() -> void:
	if not GameState.notification_active and fix_button.visible:
		notification_panel.hide()
	day_label.text = "Day %d" % GameState.day
	_update_clock_hud()
	research_label.text = "Research: %.1f%%" % GameState.research_progress
	sessions_label.text = "Work sessions: %d / 4" % GameState.work_sessions_remaining
	weekday_label.text = ["Monday", "Tuesday", "Wednesday"][clampi(GameState.day - 1, 0, 2)]
	overview_bar.value = GameState.research_progress
	_update_sidebar()
	if (GameState.day_ended or GameState.game_finished) and not GameState.research_active:
		notification_panel.hide()
		get_node("../TipTop").prepare_for_sleep()
		get_tree().paused = true
		loop_panel.show()
		if GameState.game_finished:
			loop_panel.hide()
		else:
			loop_message.text = "Day %d complete — 8:00 PM\nResearch: %.1f%%\nShowcase deadline: Day 3, 8:00 PM" % [GameState.day, GameState.research_progress]
			loop_button.text = "Showcase" if GameState.day == 3 else "Next day"


func _prepare_showcase() -> void:
	if is_instance_valid(showcase):
		return
	# Preserve the original outcome predicates and snapshot before any restart.
	if GameState.research_progress >= GameState.GOOD_ENDING_RESEARCH_THRESHOLD and GameState.tiptop_fixed:
		ending_kind = "good"
	elif GameState.research_progress >= GameState.GOOD_ENDING_RESEARCH_THRESHOLD:
		ending_kind = "bittersweet"
	else:
		ending_kind = "bad"
	SaveStore.record_ending(ending_kind)
	var scene: PackedScene = load("res://scenes/showcase_%s.tscn" % ending_kind)
	showcase = scene.instantiate() as Control
	showcase.set("research", GameState.research_progress)
	showcase.set("repaired_count", GameState.repairs.values().count(true))
	showcase.connect("restart_requested", _restart_from_pause.bind(true))
	showcase.connect("main_menu_requested", _restart_from_pause.bind(false))
	add_child(showcase)
	# Existing comic UI renders above the stage; the wipe stays on layer 128.
	move_child(dialogue_overlay, get_child_count() - 1)
	dialogue_lines.clear()
	pending_feedback.clear()
	deferred_story_events.clear()
	transition_events.clear()
	system_messages.clear()
	system_left = 0
	morning_pending_day = 0
	dialogue_resume_loop = false
	dialogue_overlay.hide()
	system_notice.hide()
	loop_panel.hide()
	get_node("../Player").interaction_prompt.hide()
	get_node("../TipTop").clear_monologue()
	get_node("../TipTop").action_label.hide()


func _show_malfunction(message: String) -> void:
	# Keep actionable choices, but put narrative in the shared presentation.
	notification_label.text = "Faulty routines: repair or ignore?" if GameState.ending_day_pending else "Tap running: repair or ignore?"
	fix_button.visible = true
	ignore_button.visible = true
	notification_panel.visible = not GameState.research_active and not get_node("../Player").animation_busy and not dialogue_overlay.visible
	get_node("../Player").interaction_prompt.hide()


func _on_fix_pressed() -> void:
	if transitioning or get_node("../Player").animation_busy:
		return
	GameState.fix_tap()


func _on_ignore_pressed() -> void:
	if transitioning or get_node("../Player").animation_busy:
		return
	notification_panel.visible = false
	GameState.ignore_tap()


func _hud_card(bounds: Rect2) -> Panel:
	var panel := Panel.new()
	panel.position = bounds.position
	panel.size = bounds.size
	panel.mouse_filter = Control.MOUSE_FILTER_IGNORE
	var style := StyleBoxFlat.new()
	style.bg_color = Color("23242bd9")
	style.border_color = Color("565459")
	style.set_border_width_all(1)
	style.set_corner_radius_all(4)
	panel.add_theme_stylebox_override("panel", style)
	add_child(panel)
	move_child(panel, 0)
	return panel


func _build_needs_ui() -> void:
	var card := _hud_card(Rect2(162, 4, 146, 30))
	hunger_label = _hud_text(card, "", Vector2(15, 1), 6)
	mood_label = _hud_text(card, "", Vector2(88, 1), 6)
	hunger_bar = ProgressBar.new()
	mood_bar = ProgressBar.new()
	hunger_fill = StyleBoxFlat.new()
	mood_fill = StyleBoxFlat.new()
	for bar in [hunger_bar, mood_bar]:
		bar.show_percentage = false
		_style_thin_bar(bar)
		bar.size = Vector2(64, 3)
		bar.mouse_filter = Control.MOUSE_FILTER_IGNORE
		card.add_child(bar)
	hunger_bar.position = Vector2(4, 12)
	mood_bar.position = Vector2(77, 12)
	hunger_bar.add_theme_stylebox_override("fill", hunger_fill)
	mood_bar.add_theme_stylebox_override("fill", mood_fill)
	hunger_status_label = _hud_text(card, "", Vector2(4, 20), 5)
	mood_hint = _hud_text(card, "", Vector2(77, 20), 5)
	for spec in [["food", 4, "Fullness"], ["needs", 77, "Mood"]]:
		var icon := TextureRect.new()
		icon.texture = _hud_icon(spec[0])
		icon.position = Vector2(spec[1], 1)
		icon.size = Vector2(9, 9)
		icon.mouse_filter = Control.MOUSE_FILTER_IGNORE
		icon.set_meta("pixel_icon", true)
		card.add_child(icon)
		var hit := Button.new()
		hit.position = Vector2(spec[1] - 2, 0)
		hit.size = Vector2(69, 30)
		hit.accessibility_name = spec[2]
		hit.set_meta("details_category", "needs")
		for state in ["normal", "hover", "pressed"]:
			hit.add_theme_stylebox_override(state, StyleBoxEmpty.new())
		var focus := StyleBoxFlat.new()
		focus.bg_color = Color.TRANSPARENT
		focus.border_color = Color("e6b369")
		focus.set_border_width_all(1)
		focus.set_corner_radius_all(3)
		hit.add_theme_stylebox_override("focus", focus)
		card.add_child(hit)
		detail_buttons["top_" + str(spec[0])] = hit
	sessions_label.hide()
	detail_controller.call("setup", self, detail_buttons, detail_groups, detail_panel, sidebar, UI_REFERENCE.y, icon_label_gutter)


func _side_section() -> VBoxContainer:
	var panel := PanelContainer.new()
	panel.add_theme_stylebox_override("panel", _detail_style())
	sidebar.add_child(panel)
	var body := VBoxContainer.new()
	body.add_theme_constant_override("separation", 2)
	body.mouse_filter = Control.MOUSE_FILTER_IGNORE
	panel.add_child(body)
	return body


func _detail_style() -> StyleBoxFlat:
	var style := StyleBoxFlat.new()
	style.bg_color = Color("23242bf5")
	style.border_color = Color("565459")
	style.set_border_width_all(1)
	style.set_corner_radius_all(4)
	style.set_content_margin_all(5)
	return style


func _hud_icon(category: String) -> Texture2D:
	# Tiny monochrome pixel icons, built once; no emoji or external assets.
	var patterns := {
		"research": [".###.###.", ".#..#..#.", ".#..#..#.", ".#.###.#.", ".#..#..#.", ".#..#..#.", ".###.###.", "....#....", "........."],
		"repairs": ["..#####..", ".#.....#.", ".#.#.#.#.", ".#.....#.", "..#####..", "....#....", "..#####..", ".#..#..#.", "........."],
		"time": ["..#####..", ".#.....#.", "#...#...#", "#...#...#", "#...###.#", "#.......#", ".#.....#.", "..#####..", "........."],
		"needs": [".##...##.", "#..#.#..#", "#...#...#", "#.......#", ".#.....#.", "..#...#..", "...#.#...", "....#....", "........."],
		"warning": ["....#....", "...#.#...", "..#.#.#..", "..#.#.#..", ".#..#..#.", ".#.....#.", "#...#...#", "#########", "........."],
		"cleanup": ["......#..", ".....#...", "....#....", "...#.....", "..####...", ".######..", "#.#.#.#..", "########.", "........."],
		"leisure": ["..#####..", ".#..#..#.", "#..#.#..#", "#..#.#..#", "#...#...#", ".#..#..#.", "..#####..", ".........", "........."],
		"food": ["#.#.#....", "#.#.#..#.", "#####..#.", "..#....#.", "..#....#.", "..#....#.", "..#....#.", "..#....#.", "........."]}
	var image := Image.create(9, 9, false, Image.FORMAT_RGBA8)
	image.fill(Color.TRANSPARENT)
	var rows: Array = patterns[category]
	for y in range(9):
		for x in range(9):
			if rows[y][x] == "#":
				image.set_pixel(x, y, Color("eadbc0"))
	return ImageTexture.create_from_image(image)


func _detail_text(parent: Node, text: String, font_size: int = 7) -> Label:
	var label := _hud_text(parent, text, Vector2.ZERO, font_size)
	label.custom_minimum_size.x = 72
	label.autowrap_mode = TextServer.AUTOWRAP_WORD_SMART
	label.add_theme_constant_override("line_spacing", 1)
	return label


func _detail_header(parent: Node, icon_name: String, text: String) -> void:
	var row := HBoxContainer.new()
	row.add_theme_constant_override("separation", 4)
	parent.add_child(row)
	_detail_icon(row, icon_name)
	var title := _hud_text(row, text, Vector2.ZERO, 8)
	title.add_theme_color_override("font_color", Color("e6b369"))
	_detail_divider(parent)


func _detail_icon(parent: Node, category: String) -> void:
	var icon := TextureRect.new()
	icon.texture = _hud_icon(category)
	icon.expand_mode = TextureRect.EXPAND_IGNORE_SIZE
	icon.custom_minimum_size = Vector2(9, 9)
	icon.size_flags_vertical = Control.SIZE_SHRINK_CENTER
	icon.mouse_filter = Control.MOUSE_FILTER_IGNORE
	icon.set_meta("pixel_icon", true)
	parent.add_child(icon)


func _detail_row(parent: Node, icon_name: String, caption: String, value: String) -> Label:
	var row := HBoxContainer.new()
	row.add_theme_constant_override("separation", 3)
	parent.add_child(row)
	_detail_icon(row, icon_name)
	var name_label := _hud_text(row, caption, Vector2.ZERO, 6)
	name_label.size_flags_horizontal = Control.SIZE_EXPAND_FILL
	var amount := _hud_text(row, value, Vector2.ZERO, 7)
	amount.horizontal_alignment = HORIZONTAL_ALIGNMENT_RIGHT
	amount.add_theme_color_override("font_color", Color("e6b369"))
	return amount


func _detail_notice(parent: Node, icon_name: String, text: String) -> HBoxContainer:
	var row := HBoxContainer.new()
	row.add_theme_constant_override("separation", 3)
	parent.add_child(row)
	_detail_icon(row, icon_name)
	var label := _hud_text(row, text, Vector2.ZERO, 6)
	label.autowrap_mode = TextServer.AUTOWRAP_WORD_SMART
	label.size_flags_horizontal = Control.SIZE_EXPAND_FILL
	label.add_theme_color_override("font_color", Color("d3987b"))
	row.set_meta("notice_label", label)
	return row


func _set_notice(row: Control, text: String) -> void:
	var label: Label = row.get_meta("notice_label")
	label.text = text
	row.visible = not text.is_empty()


func _detail_divider(parent: Node) -> void:
	var line := ColorRect.new()
	line.custom_minimum_size.y = 1
	line.color = Color("514c50")
	line.mouse_filter = Control.MOUSE_FILTER_IGNORE
	parent.add_child(line)


func _build_right_sidebar() -> void:
	sidebar = VBoxContainer.new()
	sidebar.position = Vector2(SIDEBAR_X, 4)
	sidebar.size = Vector2(96, 0)
	sidebar.add_theme_constant_override("separation", 3)
	sidebar.mouse_filter = Control.MOUSE_FILTER_IGNORE
	add_child(sidebar)
	var progress := _side_section()
	research_label.reparent(progress, false)
	research_label.horizontal_alignment = HORIZONTAL_ALIGNMENT_LEFT
	research_label.add_theme_font_size_override("font_size", 9)
	overview_bar = ProgressBar.new()
	overview_bar.show_percentage = false
	_style_thin_bar(overview_bar)
	overview_bar.custom_minimum_size = Vector2(0, 7)
	var fill := StyleBoxFlat.new()
	fill.bg_color = Color("639dad")
	overview_bar.add_theme_stylebox_override("fill", fill)
	progress.add_child(overview_bar)
	var marker := ColorRect.new()
	marker.color = Color("f3d087")
	marker.mouse_filter = Control.MOUSE_FILTER_IGNORE
	overview_bar.add_child(marker)
	marker.anchor_left = GameState.GOOD_ENDING_RESEARCH_THRESHOLD / 100.0
	marker.anchor_right = marker.anchor_left
	marker.anchor_bottom = 1.0
	marker.offset_right = 1
	_hud_text(progress, "Target: %.0f%%" % GameState.GOOD_ENDING_RESEARCH_THRESHOLD, Vector2.ZERO, 6)
	deadline_label = _hud_text(progress, "", Vector2.ZERO, 6)
	deadline_bar = ProgressBar.new()
	deadline_bar.show_percentage = false
	deadline_bar.step = 0.0
	_style_thin_bar(deadline_bar)
	deadline_bar.custom_minimum_size = Vector2(0, 3)
	deadline_bar.mouse_filter = Control.MOUSE_FILTER_IGNORE
	deadline_fill = StyleBoxFlat.new()
	deadline_bar.add_theme_stylebox_override("fill", deadline_fill)
	progress.add_child(deadline_bar)
	var categories := HBoxContainer.new()
	categories.add_theme_constant_override("separation", 0)
	sidebar.add_child(categories)
	for category in ["research", "repairs", "time", "needs"]:
		var button := Button.new()
		button.icon = _hud_icon(category)
		button.icon_alignment = HORIZONTAL_ALIGNMENT_CENTER
		button.custom_minimum_size = Vector2(24, 22)
		button.size_flags_horizontal = Control.SIZE_EXPAND_FILL
		button.accessibility_name = {"research": "Research", "repairs": "TipTop", "time": "Time Usage", "needs": "Needs"}[category]
		button.set_meta("details_category", category)
		button.set_meta("pixel_icon", true)
		for state in ["normal", "hover", "pressed", "focus"]:
			var style := _detail_style()
			style.set_content_margin_all(3)
			if state != "normal":
				style.border_color = Color("e6b369")
			button.add_theme_stylebox_override(state, style)
		categories.add_child(button)
		detail_buttons[category] = button
	icon_label_gutter = Control.new()
	icon_label_gutter.custom_minimum_size = Vector2(96, 14)
	icon_label_gutter.mouse_filter = Control.MOUSE_FILTER_IGNORE
	sidebar.add_child(icon_label_gutter)
	problem_count = _hud_text(sidebar, "", Vector2.ZERO, 6)
	compact_warning = _hud_text(sidebar, "", Vector2.ZERO, 6)
	compact_warning.autowrap_mode = TextServer.AUTOWRAP_WORD_SMART
	compact_warning.add_theme_color_override("font_color", Color("d3987b"))
	detail_panel = PanelContainer.new()
	detail_panel.add_theme_stylebox_override("panel", _detail_style())
	detail_panel.size = Vector2(96, 145)
	detail_panel.hide()
	add_child(detail_panel)
	var scroll := ScrollContainer.new()
	scroll.horizontal_scroll_mode = ScrollContainer.SCROLL_MODE_DISABLED
	scroll.focus_mode = Control.FOCUS_ALL
	scroll.follow_focus = true
	detail_panel.add_child(scroll)
	var pages := VBoxContainer.new()
	pages.size_flags_horizontal = Control.SIZE_EXPAND_FILL
	scroll.add_child(pages)
	for category in ["research", "repairs", "time", "needs"]:
		var group := VBoxContainer.new()
		group.size_flags_horizontal = Control.SIZE_EXPAND_FILL
		group.add_theme_constant_override("separation", 3)
		pages.add_child(group)
		detail_groups[category] = group
		_detail_header(group, category, {"research": "Research", "repairs": "TipTop", "time": "Time Usage", "needs": "Needs"}[category])
	var research: VBoxContainer = detail_groups["research"]
	detail_research = _detail_text(research, "", 7)
	detail_research.add_theme_color_override("font_color", Color("e6b369"))
	efficiency_label = _detail_row(research, "research", "Efficiency", "")
	_detail_divider(research)
	for key in ["food", "tap", "books", "mood", "push"]:
		research_modifiers[key] = _detail_notice(research, "warning", "")
	research_next = _detail_text(research, "", 7)
	var problems: VBoxContainer = detail_groups["repairs"]
	var names := ["Sink", "Plant", "Bookshelf", "Bed"]
	for index in range(GameState.REPAIR_ROUTINES.size()):
		var row := RichTextLabel.new()
		row.bbcode_enabled = true
		row.fit_content = true
		row.scroll_active = false
		row.mouse_filter = Control.MOUSE_FILTER_IGNORE
		row.add_theme_font_size_override("normal_font_size", 7)
		row.set_meta("routine_name", names[index])
		problems.add_child(row)
		problem_rows[GameState.REPAIR_ROUTINES[index]] = row
	_detail_divider(problems)
	detail_repair_count = _detail_text(problems, "", 7)
	var usage: VBoxContainer = detail_groups["time"]
	usage_title = _detail_text(usage, "", 7)
	var distribution := HBoxContainer.new()
	distribution.custom_minimum_size = Vector2(0, 4)
	distribution.add_theme_constant_override("separation", 0)
	usage.add_child(distribution)
	_detail_divider(usage)
	var captions := ["Research", "Eating", "Leisure", "Repairs", "Cleanup", "Misc"]
	var icons := ["research", "food", "leisure", "repairs", "cleanup", "time"]
	for index in range(GameState.TIME_CATEGORIES.size()):
		var category: String = GameState.TIME_CATEGORIES[index]
		var segment := ColorRect.new()
		segment.color = TIME_COLORS[index]
		segment.size_flags_horizontal = Control.SIZE_EXPAND_FILL
		segment.mouse_filter = Control.MOUSE_FILTER_IGNORE
		distribution.add_child(segment)
		usage_segments[category] = segment
		var row := _detail_row(usage, icons[index], captions[index], "")
		row.modulate = TIME_COLORS[index]
		usage_rows[category] = row
	var needs: VBoxContainer = detail_groups["needs"]
	needs_values["food"] = _detail_row(needs, "food", "Fullness", "")
	needs_values["mood"] = _detail_row(needs, "needs", "Mood", "")
	detail_needs = _detail_text(needs, "", 6)
	_detail_text(needs, "Meal: 30 min, +40 food, +10 Mood. Counts as a break.", 6)
	_detail_divider(needs)
	for key in ["food", "mood"]:
		needs_modifiers[key] = _detail_notice(needs, "warning", "")
	detail_controller = Node.new()
	detail_controller.set_script(preload("res://scripts/hud_details.gd"))
	add_child(detail_controller)


func _update_sidebar() -> void:
	var fixed_count := 0
	for chore in problem_rows:
		var row: RichTextLabel = problem_rows[chore]
		var fixed: bool = GameState.repairs[chore]
		var text: String = row.get_meta("routine_name")
		var content := "[color=#9dceac]✓ [s]%s[/s][/color]" % text if fixed else "□ " + text
		if row.text != content:
			row.text = content
		fixed_count += int(fixed)
	problem_count.text = "TipTop: %d/4 fixed" % fixed_count
	detail_repair_count.text = "%d / 4 repaired" % fixed_count
	var blocked := not GameState.research_available() or GameState.work_sessions_remaining <= 0
	detail_research.text = "Research underway" if GameState.research_active else ("Research blocked" if blocked else "Ready to research")
	var food_loss := int(round((1.0 - GameState.hunger_efficiency()) * 100))
	_set_notice(research_modifiers["food"], "Fullness must exceed 20" if not GameState.fullness_allows_research() else ("Food: -%d%% yield" % food_loss if food_loss > 0 else ""))
	_set_notice(research_modifiers["tap"], "Tap: half reward" if GameState.tap_running else "")
	_set_notice(research_modifiers["books"], "Books scattered" if int(GameState.chore_mess["bookshelf"]) >= 2 else "")
	_set_notice(research_modifiers["mood"], "Mood below 45" if not GameState.mood_allows_research() else "")
	_set_notice(research_modifiers["push"], "Push-through: -20%" if GameState.pushing_through() else "")
	var recommendation := "Your desk is ready."
	if GameState.work_sessions_remaining <= 0:
		recommendation = "Rest for more sessions."
	elif not GameState.fullness_allows_research():
		recommendation = "Eat before researching."
	elif int(GameState.chore_mess["bookshelf"]) >= 2:
		recommendation = "Clear the bookshelf."
	elif not GameState.mood_allows_research():
		recommendation = "Take a coffee-table break."
	elif not GameState.has_research_time():
		recommendation = "A full session won't fit today."
	elif food_loss > 0:
		recommendation = "Eat before your next session."
	elif GameState.tap_running:
		recommendation = "Turn off the tap."
	research_next.text = recommendation
	var warning := ""
	if not GameState.fullness_allows_research():
		warning = "! Too hungry to work"
	elif int(GameState.chore_mess["bookshelf"]) >= 2:
		warning = "! Books block research"
	elif not GameState.mood_allows_research():
		warning = "! Mood blocks research"
	elif GameState.hunger < 25:
		warning = "! Eat soon"
	elif not GameState.has_research_time() and GameState.work_sessions_remaining > 0:
		warning = "! Not enough work time"
	compact_warning.text = warning
	compact_warning.visible = not warning.is_empty()
	var totals := GameState.displayed_daily_time()
	var elapsed := 0.0
	for category in GameState.TIME_CATEGORIES:
		var minutes: float = totals[category]
		elapsed += minutes
		var row: Label = usage_rows[category]
		row.text = _minutes_text(minutes)
		var segment: ColorRect = usage_segments[category]
		segment.visible = minutes > 0
		segment.size_flags_stretch_ratio = maxf(0.0001, minutes)
	usage_title.text = "Total: " + _minutes_text(elapsed)


func _minutes_text(minutes: float) -> String:
	var whole := int(floor(minutes + 0.000001))
	return "%dh %02dm" % [whole / 60, whole % 60]


func _update_needs_ui() -> void:
	hunger_label.text = "Full: %d%%" % int(GameState.hunger)
	mood_label.text = "Mood: %d%%" % int(GameState.mood)
	hunger_bar.value = GameState.hunger
	mood_bar.value = GameState.mood
	hunger_fill.bg_color = _muted_gradient(GameState.hunger, [0.0, 24.0, 45.0, 60.0, 75.0, 100.0], [Color("aa625c"), Color("aa625c"), Color("c28764"), Color("c6a367"), Color("92aa85"), Color("92aa85")])
	mood_fill.bg_color = Color("c28764") if GameState.mood < 45 else Color("83aaa2")
	mood_label.modulate = Color("dca69a") if GameState.mood < 45 else Color.WHITE
	mood_hint.text = "Push through (-20%)" if GameState.pushing_through() else ("Rest needed (<45)" if GameState.mood < 45 else "Ready for research")
	efficiency_label.text = "%d%%" % int(round(GameState.research_efficiency() * 100))
	hunger_status_label.text = "! Critical fullness" if GameState.hunger < 25 else GameState.hunger_status()
	if GameState.hunger < 60:
		var food_penalty := int(round((1.0 - GameState.hunger_efficiency()) * 100))
		hunger_status_label.text = ("! Critical" if GameState.hunger < 25 else GameState.hunger_status()) + " (-%d%%)" % food_penalty
	hunger_status_label.modulate = Color("92aa85") if GameState.hunger >= 75 else (Color("dca69a") if GameState.hunger <= 45 else Color.WHITE)
	needs_values["food"].text = "%d%%" % int(GameState.hunger)
	needs_values["mood"].text = "%d%%" % int(GameState.mood)
	detail_needs.text = GameState.hunger_status() + (" / Low Mood" if GameState.mood < 45 else " / Mood steady")
	var loss := int(round((1.0 - GameState.hunger_efficiency()) * 100))
	_set_notice(needs_modifiers["food"], "Too hungry to start research. Eat: +40 food, +10 Mood." if not GameState.fullness_allows_research() else ("Food: -%d%% yield. Meals: +40 food, +10 Mood." % loss if loss > 0 else ""))
	_set_notice(needs_modifiers["mood"], "Push-through: -20% yield." if GameState.pushing_through() else ("Mood below 45. Take a leisure break." if GameState.mood < 45 else ""))


func _muted_gradient(value: float, stops: Array, colors: Array) -> Color:
	for index in range(1, stops.size()):
		if value <= float(stops[index]):
			var weight := inverse_lerp(float(stops[index - 1]), float(stops[index]), value)
			var previous: Color = colors[index - 1]
			return previous.lerp(colors[index], clampf(weight, 0, 1))
	return colors.back()


func _hud_text(parent: Node, text: String, point: Vector2, font_size: int) -> Label:
	var label := Label.new()
	label.text = text
	label.position = point
	label.add_theme_font_size_override("font_size", font_size)
	label.mouse_filter = Control.MOUSE_FILTER_IGNORE
	parent.add_child(label)
	return label


func _build_loop_ui() -> void:
	var day_card := _hud_card(Rect2(5, 4, 154, 35))
	var sun := Polygon2D.new()
	var points := PackedVector2Array()
	for index in range(12):
		points.append(Vector2(8, 8) + Vector2.from_angle(index * TAU / 12.0) * 3.0)
	sun.polygon = points
	sun.color = Color("f3c76c")
	day_card.add_child(sun)
	for index in range(8):
		var ray := Line2D.new()
		var direction := Vector2.from_angle(index * TAU / 8.0)
		ray.points = PackedVector2Array([Vector2(8, 8) + direction * 4.0, Vector2(8, 8) + direction * 6.0])
		ray.width = 1.0
		ray.default_color = sun.color
		day_card.add_child(ray)
	day_label.position = Vector2(23, 5)
	day_label.size = Vector2(32, 9)
	day_label.add_theme_font_size_override("font_size", 7)
	weekday_label = _hud_text(self, "Monday", Vector2(23, 15), 6)
	var divider := ColorRect.new()
	divider.position = Vector2(57, 7)
	divider.size = Vector2(1, 19)
	divider.color = Color("98949a")
	add_child(divider)
	time_label.position = Vector2(62, 6)
	time_label.size = Vector2(88, 13)
	time_label.add_theme_font_size_override("font_size", 9)
	time_remaining = _hud_text(self, "", Vector2(66, 20), 6)
	time_bar = ProgressBar.new()
	time_bar.show_percentage = false
	_style_thin_bar(time_bar)
	time_bar.position = Vector2(6, 29)
	time_bar.size = Vector2(142, 3)
	time_bar_fill = StyleBoxFlat.new()
	time_bar_fill.bg_color = Color("e1bd70")
	time_bar.add_theme_stylebox_override("fill", time_bar_fill)
	day_card.add_child(time_bar)
	_build_right_sidebar()
	var controls := _hud_card(Rect2(5, 242, 54, 28))
	var controls_text := _hud_text(controls, "E   Interact\nESC Pause", Vector2(4, 3), 7)
	controls_text.add_theme_constant_override("line_spacing", 0)
	sessions_label = _hud_text(self, "", Vector2(304, 274), 6)
	loop_panel = ColorRect.new()
	loop_panel.position = Vector2(66, 55)
	loop_panel.size = Vector2(300, 160)
	loop_panel.color = Color(0.08, 0.08, 0.12, 0.98)
	add_child(loop_panel)
	loop_message = Label.new()
	loop_message.position = Vector2(8, 8)
	loop_message.size = Vector2(284, 48)
	loop_message.add_theme_font_size_override("font_size", 8)
	loop_message.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
	loop_message.autowrap_mode = TextServer.AUTOWRAP_WORD_SMART
	loop_message.text = "Day 3 showcase: reach %.0f%% and repair all routines.\nE to interact. Make the bed before resting.\nFour sessions/day; full sessions must fit before 8:00 PM." % GameState.GOOD_ENDING_RESEARCH_THRESHOLD
	loop_panel.add_child(loop_message)
	loop_button = Button.new()
	loop_button.position = Vector2(100, 130)
	loop_button.size = Vector2(100, 24)
	loop_button.add_theme_font_size_override("font_size", 8)
	loop_button.text = "Start"
	loop_button.pressed.connect(_on_loop_pressed)
	loop_panel.add_child(loop_button)
	difficulty_controls = HBoxContainer.new()
	difficulty_controls.position = Vector2(12, 62)
	difficulty_controls.size = Vector2(276, 22)
	difficulty_controls.add_theme_constant_override("separation", 3)
	loop_panel.add_child(difficulty_controls)
	for index in range(GameState.DIFFICULTIES.size()):
		var button := Button.new()
		button.text = GameState.DIFFICULTIES[index]["name"]
		button.toggle_mode = true
		button.size_flags_horizontal = Control.SIZE_EXPAND_FILL
		button.add_theme_font_size_override("font_size", 7)
		button.pressed.connect(_choose_difficulty.bind(index))
		difficulty_controls.add_child(button)
	difficulty_description = Label.new()
	difficulty_description.position = Vector2(12, 90)
	difficulty_description.size = Vector2(276, 32)
	difficulty_description.autowrap_mode = TextServer.AUTOWRAP_WORD_SMART
	difficulty_description.add_theme_font_size_override("font_size", 6)
	loop_panel.add_child(difficulty_description)
	_choose_difficulty(GameState.difficulty)
	get_tree().paused = true


func _choose_difficulty(index: int) -> void:
	GameState.select_difficulty(index)
	for item in range(difficulty_controls.get_child_count()):
		var button: Button = difficulty_controls.get_child(item)
		button.set_pressed_no_signal(item == GameState.difficulty)
	difficulty_description.text = "%s\nResearch %.0f min / +%.0f%%; repair %d min / +%.0f%%." % [GameState.profile()["description"], GameState.profile()["research_minutes"], GameState.profile()["research"], GameState.repair_minutes(), GameState.profile()["repair_reward"]]


func _on_loop_pressed() -> void:
	if transitioning or sleep_dialogue_pending or get_node("../Player").animation_busy:
		return
	if GameState.game_finished:
		_play_day_transition(true)
		return
	if GameState.day_ended:
		_play_day_transition()
		return
	# The legacy Start button also enters through the same rules gate.
	if not tutorial_entry and not rules_acknowledged:
		_show_campaign_rules()
		return
	loop_panel.hide()
	if SaveStore.campaign_id.is_empty():
		SaveStore.new_campaign(tutorial_entry)
	GameState.difficulty_locked = true
	difficulty_controls.hide()
	difficulty_description.hide()
	get_tree().paused = false
	if not story_seen.has("opening"):
		morning_pending_day = GameState.day
		_on_story_event("opening")


func _show_campaign_rules() -> void:
	rules_review = false
	loop_panel.hide()
	detail_controller.call("exit_navigation")
	rules_intro.call("open")


func _rules_dismissed() -> void:
	if rules_review:
		rules_review = false
		_restore_modal_pause()
	else:
		rules_acknowledged = true
		_on_loop_pressed()


func _build_transition_ui() -> void:
	var transition_layer := CanvasLayer.new()
	transition_layer.layer = 128
	add_child(transition_layer)
	transition_cover = ColorRect.new()
	transition_cover.color = Color.BLACK
	transition_cover.size = Vector2(384, 288)
	transition_cover.size.x = UI_REFERENCE.x
	transition_cover.hide()
	transition_layer.add_child(transition_cover)
	transition_title = Label.new()
	transition_title.position = Vector2(0, 132)
	transition_title.size = Vector2(UI_REFERENCE.x, 24)
	transition_title.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
	transition_title.add_theme_font_size_override("font_size", 14)
	transition_title.texture_filter = CanvasItem.TEXTURE_FILTER_LINEAR
	transition_cover.add_child(transition_title)


func _play_day_transition(restarting := false) -> void:
	if transitioning or (not restarting and not GameState.day_ended):
		return
	if not restarting and get_node("../TipTop").goodnight_day != GameState.day:
		if not _comic_safe() or dialogue_overlay.visible or not dialogue_lines.is_empty():
			return
		loop_panel.hide()
		sleep_dialogue_pending = true
		get_node("../TipTop").say_goodnight()
		return
	transitioning = true
	loop_button.disabled = true
	get_tree().paused = true
	transition_title.hide()
	if not restarting:
		loop_panel.hide()
		GameState.apply_overnight_needs()
		await get_node("../Player").play_sleep_animation()
	transition_cover.position = Vector2(-UI_REFERENCE.x, 0)
	transition_cover.show()
	var wipe := create_tween().set_pause_mode(Tween.TWEEN_PAUSE_PROCESS)
	wipe.set_trans(Tween.TRANS_SINE).set_ease(Tween.EASE_IN_OUT)
	wipe.tween_property(transition_cover, "position:x", 0.0, 0.65)
	await wipe.finished
	get_node("../TipTop").clear_monologue()
	if restarting:
		GameState.restart()
		get_tree().change_scene_to_file("res://scenes/title.tscn")
		return
	loop_panel.hide()
	# Advance once, under full black; story dialogue is deferred until reveal.
	GameState.continue_day()
	# Release the sleep-pose lock before the shared comic dialogue can start.
	get_node("../Player").wake_from_bed()
	if GameState.game_finished:
		_prepare_showcase()
	transition_title.text = "Showcase" if GameState.game_finished else "Day %d" % GameState.day
	transition_title.show()
	await get_tree().create_timer(0.45).timeout
	transition_title.hide()
	var reveal := create_tween().set_pause_mode(Tween.TWEEN_PAUSE_PROCESS)
	reveal.set_trans(Tween.TRANS_SINE).set_ease(Tween.EASE_IN_OUT)
	reveal.tween_property(transition_cover, "position:x", UI_REFERENCE.x, 0.65)
	await reveal.finished
	transition_cover.hide()
	loop_button.disabled = false
	transitioning = false
	if GameState.game_finished:
		_on_story_event("ending")
		get_tree().paused = true
		return
	var events := transition_events.duplicate()
	transition_events.clear()
	for event in events:
		_on_story_event(event)
	get_tree().paused = dialogue_overlay.visible or loop_panel.visible or GameState.day_ended or GameState.game_finished
	SaveStore.request_autosave("new_day")


func _reveal_new_game() -> void:
	transitioning = true
	loop_button.disabled = true
	transition_cover.position = Vector2.ZERO
	transition_cover.show()
	transition_title.text = "New Game"
	transition_title.show()
	await get_tree().create_timer(0.45).timeout
	transition_title.hide()
	var reveal := create_tween().set_pause_mode(Tween.TWEEN_PAUSE_PROCESS)
	reveal.set_trans(Tween.TRANS_SINE).set_ease(Tween.EASE_IN_OUT)
	reveal.tween_property(transition_cover, "position:x", UI_REFERENCE.x, 0.65)
	await reveal.finished
	transition_cover.hide()
	loop_button.disabled = false
	transitioning = false
	# The existing Start panel and opening dialogue handle the fresh game.
	get_tree().paused = true


func _build_repair_menu() -> void:
	repair_panel = ColorRect.new()
	repair_panel.size = Vector2(384, 288)
	repair_panel.color = Color(0.08, 0.08, 0.12, 0.98)
	repair_panel.hide()
	add_child(repair_panel)
	var center := CenterContainer.new()
	repair_panel.add_child(center)
	center.set_anchors_and_offsets_preset(Control.PRESET_FULL_RECT)
	var options := VBoxContainer.new()
	options.add_theme_constant_override("separation", 5)
	center.add_child(options)
	var title := Label.new()
	title.text = "TipTop's routines - repair independently"
	title.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
	title.add_theme_font_size_override("font_size", 8)
	options.add_child(title)
	for chore in GameState.REPAIR_ROUTINES:
		var button := Button.new()
		button.custom_minimum_size = Vector2(260, 22)
		button.size_flags_horizontal = Control.SIZE_EXPAND_FILL
		button.add_theme_font_size_override("font_size", 8)
		button.add_theme_color_override("font_disabled_color", Color("9eaaa3"))
		button.pressed.connect(_select_repair.bind(chore))
		options.add_child(button)
		repair_buttons[chore] = button
	var cancel := Button.new()
	cancel.text = "Cancel"
	cancel.custom_minimum_size = Vector2(260, 22)
	cancel.add_theme_font_size_override("font_size", 8)
	cancel.pressed.connect(_close_repair_menu)
	options.add_child(cancel)
	fix_button.text = "Repairs..."


func _open_repair_menu() -> void:
	if transitioning or repair_panel.visible or dialogue_overlay.visible or loop_panel.visible or _household_open() or GameState.research_active or get_node("../Player").animation_busy:
		return
	get_node("../TipTop").clear_monologue()
	get_node("../TipTop").action_label.hide()
	for chore in repair_buttons:
		var button: Button = repair_buttons[chore]
		var fixed: bool = GameState.repairs[chore]
		var duration := GameState.repair_minutes()
		var enough_time: bool = GameState.DAY_END - GameState.time_minutes - GameState.clock_fraction - GameState.world_accumulator >= duration
		button.disabled = fixed or not enough_time
		button.text = "%s — %s (%d min, +%.0f%%)" % ["Water / sink" if chore == "sink" else chore.capitalize(), "Repaired" if fixed else ("Faulty" if enough_time else "Not enough time"), duration, float(GameState.profile()["repair_reward"])]
	repair_panel.show()
	get_tree().paused = true


func _close_repair_menu() -> void:
	repair_panel.hide()
	_restore_modal_pause()


func _select_repair(chore: String) -> void:
	if not repair_panel.visible or GameState.repairs[chore]:
		return
	_close_repair_menu()
	GameState.repair_routine(chore)


func _show_feedback(message: String) -> void:
	var speaker := "System"
	for character in ["Judy", "TipTop"]:
		if message.begins_with(character + ":"):
			speaker = character
			message = message.trim_prefix(character + ":").strip_edges()
	var expression := "neutral"
	if speaker == "System":
		var previous := dialogue_bounds
		dialogue_bounds = Vector2(184, 24)
		for page in _dialogue_pages(message):
			if not system_messages.has(page):
				system_messages.append(page)
		dialogue_bounds = previous
		return
	if speaker == "TipTop":
		if message.length() <= get_node("../TipTop").THOUGHT_LIMIT:
			get_node("../TipTop").show_monologue(message)
		else:
			var long_line := [speaker, message, expression]
			if not pending_feedback.has(long_line):
				pending_feedback.append(long_line)
		return
	if GameState.research_active:
		# Optional feedback is stale by the time a long session completes.
		return
	elif speaker == "Judy" and "Mosquito" in message:
		expression = "annoyed"
	var line := [speaker, message, expression]
	if not pending_feedback.has(line):
		pending_feedback.append(line)


func _process(delta: float) -> void:
	_update_clock_hud()
	_update_needs_ui()
	_update_sidebar()
	_sync_overlay_visibility()
	if _rules_open():
		return
	if _pause_open():
		return
	_update_activity_controls()
	if transitioning or _eject_open() or repair_panel.visible or (is_instance_valid(household_panel) and household_panel.visible):
		return
	if _comic_safe() and not dialogue_overlay.visible:
		if not deferred_story_events.is_empty():
			_on_story_event(deferred_story_events.pop_front())
		elif not dialogue_lines.is_empty():
			_advance_dialogue()
	if morning_pending_day == GameState.day and dialogue_lines.is_empty() and pending_feedback.is_empty() and deferred_story_events.is_empty() and _comic_safe() and overhead_thoughts_allowed() and not GameState.notification_active:
		if get_node("../TipTop").greet_morning():
			morning_pending_day = 0
	if not dialogue_overlay.visible and not loop_panel.visible and not GameState.notification_active and not get_node("../Player").animation_busy:
		if system_left <= 0 and not system_messages.is_empty():
			system_text.text = system_messages.pop_front()
			system_left = 2.5
		system_notice.visible = system_left > 0
		system_left = maxf(0, system_left - delta)
	if dialogue_overlay.visible and dialogue_text.visible_characters >= 0:
		reveal_characters += delta * 65.0
		dialogue_text.visible_characters = mini(int(reveal_characters), dialogue_text.get_total_character_count())
	if get_node("../Player").animation_busy:
		return
	if not pending_feedback.is_empty() and (dialogue_overlay.visible or not loop_panel.visible):
		dialogue_lines.append_array(pending_feedback)
		pending_feedback.clear()
		if not dialogue_overlay.visible:
			_advance_dialogue()


func _style_thin_bar(bar: ProgressBar) -> void:
	# Both theme styleboxes contribute minimum size, even at zero progress.
	var background := StyleBoxFlat.new()
	background.bg_color = Color("171b23")
	var fill := StyleBoxFlat.new()
	fill.bg_color = Color("639dad")
	bar.add_theme_stylebox_override("background", background)
	bar.add_theme_stylebox_override("fill", fill)
	bar.custom_minimum_size = Vector2.ZERO
	bar.size_flags_vertical = Control.SIZE_SHRINK_CENTER
	bar.mouse_filter = Control.MOUSE_FILTER_IGNORE


func _build_research_controls() -> void:
	research_strip = ColorRect.new()
	research_strip.position = Vector2(64, 242)
	research_strip.size = Vector2(248, 40)
	research_strip.color = Color("29272d")
	research_strip.hide()
	add_child(research_strip)
	research_status = _hud_text(research_strip, "", Vector2(6, 1), 7)
	research_help = _hud_text(research_strip, "", Vector2(6, 1), 6)
	research_help.size = Vector2(236, 12)
	research_help.autowrap_mode = TextServer.AUTOWRAP_WORD_SMART
	research_help.clip_text = true
	research_help.hide()
	research_bar = ProgressBar.new()
	research_bar.position = Vector2(6, 14)
	research_bar.show_percentage = false
	_style_thin_bar(research_bar)
	research_bar.size = Vector2(236, 3)
	research_strip.add_child(research_bar)
	var row := HBoxContainer.new()
	row.position = Vector2(4, 20)
	row.size = Vector2(240, 17)
	row.add_theme_constant_override("separation", 3)
	research_strip.add_child(row)
	for spec in [["Watch 1x", _set_activity_speed.bind(1.0)], ["Fast 6x", _set_activity_speed.bind(6.0)], ["Skip", _skip_research], ["Eject...", _open_eject]]:
		var button := Button.new()
		button.text = spec[0]
		button.custom_minimum_size = Vector2(0, 17)
		button.size_flags_horizontal = Control.SIZE_EXPAND_FILL
		button.add_theme_font_size_override("font_size", 7)
		button.pressed.connect(spec[1])
		row.add_child(button)
		activity_buttons.append(button)
		button.accessibility_name = spec[0]
		var help_text: String = {"Watch 1x": "Play at normal speed.", "Fast 6x": "Play at 6x speed.", "Skip": "Finish now. Full time cost applies.", "Eject...": "Cancel without a completion reward."}[spec[0]]
		button.accessibility_description = help_text
		button.set_meta("help_text", help_text)
		if spec[0] == "Watch 1x":
			activity_watch_button = button
			button.toggle_mode = true
		elif spec[0] == "Fast 6x":
			research_speed_button = button
			button.toggle_mode = true
		elif spec[0] == "Eject...":
			eject_button = button
			button.add_theme_color_override("font_color", Color("dca69a"))


func _update_activity_controls() -> void:
	var active := GameState.research_active or not GameState.personal_activity.is_empty()
	eject_button.disabled = not GameState.can_eject_task() or get_tree().paused
	eject_button.set_meta("help_text", "Cancel without a completion reward." if not eject_button.disabled else "Unavailable while paused or finishing.")
	var help_text := ""
	if research_strip.visible and not get_tree().paused:
		var focused: Control = get_viewport().gui_get_focus_owner()
		for button in activity_buttons:
			if button == focused or button.get_global_rect().has_point(button.get_global_mouse_position()):
				help_text = button.get_meta("help_text")
	research_help.text = help_text
	research_help.visible = not help_text.is_empty()
	research_status.visible = help_text.is_empty()
	if not active:
		return
	var speed: float = GameState.research_playback_rate if GameState.research_active else GameState.personal_playback_rate
	activity_watch_button.set_pressed_no_signal(speed == 1)
	research_speed_button.set_pressed_no_signal(speed > 1)
	if GameState.research_active:
		research_bar.max_value = GameState.research_duration
		research_bar.value = minf(GameState.research_duration, GameState.research_elapsed + GameState.research_accumulator)
		research_status.text = "Research: %d / %d min · %dx" % [int(GameState.research_elapsed), GameState.research_duration, int(speed)]
		if GameState.research_interruptions > 0 and fmod(GameState.research_elapsed, 5.0) < 0.25:
			research_status.text += " · Swat!"
	else:
		var duration: int = GameState.PERSONAL_ACTIVITIES[GameState.personal_activity][0]
		research_bar.max_value = duration
		research_bar.value = duration - GameState.personal_remaining
		var title: String = {"eat": "Eating", "reels": "Reels", "games": "Phone games", "cube": "Rubik's cube"}[GameState.personal_activity]
		research_status.text = "%s: %d / %d min · %dx" % [title, int(duration - GameState.personal_remaining), duration, int(speed)]


func _eject_open() -> bool:
	return is_instance_valid(eject_confirm) and eject_confirm.visible


func _build_eject_confirmation() -> void:
	eject_confirm = ColorRect.new()
	eject_confirm.color = Color(0.04, 0.04, 0.06, 0.85)
	eject_confirm.size = UI_REFERENCE
	eject_confirm.hide()
	add_child(eject_confirm)
	var center := CenterContainer.new()
	eject_confirm.add_child(center)
	center.set_anchors_and_offsets_preset(Control.PRESET_FULL_RECT)
	var panel := PanelContainer.new()
	panel.custom_minimum_size.x = 250
	panel.add_theme_stylebox_override("panel", _detail_style())
	center.add_child(panel)
	var body := VBoxContainer.new()
	body.add_theme_constant_override("separation", 7)
	panel.add_child(body)
	_hud_text(body, "Eject unfinished task?", Vector2.ZERO, 11)
	var text := _hud_text(body, "Elapsed time stays spent. No completion reward.\nA started research session stays used.", Vector2.ZERO, 8)
	text.custom_minimum_size.x = 230
	text.autowrap_mode = TextServer.AUTOWRAP_WORD_SMART
	for spec in [["Keep working", _close_eject], ["Eject task", _confirm_eject_task]]:
		var button := Button.new()
		button.text = spec[0]
		button.custom_minimum_size.y = 22
		button.add_theme_font_size_override("font_size", 9)
		button.pressed.connect(spec[1])
		body.add_child(button)
		if spec[0] == "Keep working":
			eject_confirm.set_meta("safe_focus", button)


func _open_eject() -> void:
	if get_tree().paused or not GameState.can_eject_task():
		return
	eject_confirm.show()
	get_tree().paused = true
	var safe_button: Button = eject_confirm.get_meta("safe_focus")
	safe_button.grab_focus.call_deferred()


func _close_eject() -> void:
	eject_confirm.hide()
	_restore_modal_pause()
	get_viewport().gui_release_focus()


func _confirm_eject_task() -> void:
	if not _eject_open():
		return
	if GameState.can_eject_task():
		GameState.eject_current_task()
		research_strip.hide()
	_close_eject()


func _build_system_notice() -> void:
	system_notice = ColorRect.new()
	system_notice.position = Vector2(96, 242)
	system_notice.size = Vector2(192, 30)
	system_notice.color = Color(0.08, 0.08, 0.12, 0.94)
	system_notice.mouse_filter = Control.MOUSE_FILTER_IGNORE
	system_notice.hide()
	add_child(system_notice)
	system_text = Label.new()
	system_text.position = Vector2(4, 3)
	system_text.size = Vector2(184, 24)
	system_text.add_theme_font_size_override("font_size", 7)
	system_text.add_theme_constant_override("line_spacing", 1)
	system_text.mouse_filter = Control.MOUSE_FILTER_IGNORE
	system_notice.add_child(system_text)


func _sync_overlay_visibility() -> void:
	get_node("../Desk/PromptLabel").hide()
	if dialogue_overlay.visible or _rules_open():
		get_node("../Player").interaction_prompt.hide()
		get_node("../TipTop").monologue_label.hide()
		get_node("../TipTop").action_label.hide()
	var blocked: bool = _rules_open() or _pause_open() or _eject_open() or dialogue_overlay.visible or repair_panel.visible or transitioning or loop_panel.visible or GameState.research_active or get_node("../Player").animation_busy or (is_instance_valid(household_panel) and household_panel.visible)
	notification_panel.visible = GameState.notification_active and not blocked and not GameState.day_ended and not GameState.game_finished
	if blocked or GameState.notification_active or get_node("../Player").animation_busy:
		system_notice.hide()


func _build_dialogue_ui() -> void:
	dialogue_overlay = ColorRect.new()
	dialogue_overlay.size = Vector2(384, 288)
	dialogue_overlay.color = Color(0, 0, 0, 0)
	dialogue_overlay.hide()
	add_child(dialogue_overlay)
	var panel := Control.new()
	panel.position = Vector2(60, 236)
	panel.size = Vector2(248, 60)
	panel.scale = Vector2(0.85, 0.85)
	dialogue_overlay.add_child(panel)
	dialogue_plain = ColorRect.new()
	dialogue_plain.position = Vector2(0, 16)
	dialogue_plain.size = Vector2(248, 44)
	dialogue_plain.color = Color("eadbc0")
	panel.add_child(dialogue_plain)
	dialogue_art = TextureRect.new()
	dialogue_art.size = Vector2(248, 60)
	dialogue_art.expand_mode = TextureRect.EXPAND_IGNORE_SIZE
	dialogue_art.stretch_mode = TextureRect.STRETCH_KEEP_ASPECT_CENTERED
	panel.add_child(dialogue_art)
	# Supplied panels include a baked portrait. Replace only that area at render time.
	var crop := Shader.new()
	crop.code = "shader_type canvas_item; void fragment() { vec4 pixel = texture(TEXTURE, UV); if (UV.x < 0.31) { pixel.a = 0.0; } COLOR = pixel; }"
	var material := ShaderMaterial.new()
	material.shader = crop
	dialogue_art.material = material
	dialogue_art.texture_filter = CanvasItem.TEXTURE_FILTER_NEAREST
	dialogue_portrait_frame = Control.new()
	dialogue_portrait_frame.size = Vector2(100, 73)
	dialogue_portrait_frame.scale = Vector2(0.76, 0.76)
	panel.add_child(dialogue_portrait_frame)
	var outline := Polygon2D.new()
	outline.polygon = PackedVector2Array([Vector2(0, 8), Vector2(84, 0), Vector2(101, 68), Vector2(8, 73)])
	outline.color = Color("211d26")
	dialogue_portrait_frame.add_child(outline)
	dialogue_accent = Polygon2D.new()
	dialogue_accent.polygon = PackedVector2Array([Vector2(4, 11), Vector2(81, 4), Vector2(96, 65), Vector2(11, 69)])
	dialogue_portrait_frame.add_child(dialogue_accent)
	var portrait_clip := Control.new()
	portrait_clip.position = Vector2(6, 2)
	portrait_clip.size = Vector2(86, 66)
	portrait_clip.clip_contents = true
	dialogue_portrait_frame.add_child(portrait_clip)
	dialogue_portrait = TextureRect.new()
	dialogue_portrait.size = Vector2(86, 66)
	dialogue_portrait.expand_mode = TextureRect.EXPAND_IGNORE_SIZE
	dialogue_portrait.stretch_mode = TextureRect.STRETCH_KEEP_ASPECT_CENTERED
	portrait_clip.add_child(dialogue_portrait)
	dialogue_speaker = Label.new()
	dialogue_speaker.position = Vector2(90, 8)
	dialogue_speaker.add_theme_font_size_override("font_size", 8)
	dialogue_speaker.add_theme_color_override("font_color", Color.WHITE)
	dialogue_speaker.add_theme_color_override("font_outline_color", Color("211d26"))
	dialogue_speaker.add_theme_constant_override("outline_size", 1)
	panel.add_child(dialogue_speaker)
	dialogue_text = Label.new()
	dialogue_text.position = Vector2(87, 22)
	dialogue_text.size = Vector2(150, 26)
	dialogue_text.add_theme_font_size_override("font_size", 7)
	dialogue_text.add_theme_constant_override("line_spacing", 1)
	dialogue_text.add_theme_color_override("font_color", Color("302731"))
	panel.add_child(dialogue_text)
	var hint := Label.new()
	dialogue_hint = hint
	hint.position = Vector2(153, 53)
	hint.text = "E / Enter - Next"
	hint.add_theme_font_size_override("font_size", 6)
	panel.add_child(hint)
	for speaker in ["judy", "tiptop"]:
		var expressions := ["neutral", "happy", "annoyed", "surprised"] if speaker == "judy" else ["neutral", "proud", "confused", "error", "worried", "overwhelmed"]
		for expression in expressions + ["dialogue_panel"]:
			var path := "res://assets/dialogue/%s_%s.png" % [speaker, expression]
			portrait_cache[speaker + "_" + expression] = load(path)
	# Smooth default text remains readable; supplied artwork uses crisp sampling.
	dialogue_art.set_meta("dialogue_pixel_art", true)
	dialogue_portrait.set_meta("dialogue_pixel_art", true)


func _build_pause_menu() -> void:
	pause_panel = ColorRect.new()
	pause_panel.color = Color(0.05, 0.06, 0.08, 0.92)
	pause_panel.size = UI_REFERENCE
	pause_panel.hide()
	add_child(pause_panel)
	var center := CenterContainer.new()
	pause_panel.add_child(center)
	center.set_anchors_and_offsets_preset(Control.PRESET_FULL_RECT)
	var panel := PanelContainer.new()
	var style := StyleBoxFlat.new()
	style.bg_color = Color("23242b")
	style.border_color = Color("78747a")
	style.set_border_width_all(1)
	style.set_corner_radius_all(5)
	style.content_margin_left = 10
	style.content_margin_right = 10
	style.content_margin_top = 10
	style.content_margin_bottom = 10
	panel.add_theme_stylebox_override("panel", style)
	center.add_child(panel)
	var choices := VBoxContainer.new()
	choices.add_theme_constant_override("separation", 5)
	panel.add_child(choices)
	_hud_text(choices, "Paused", Vector2.ZERO, 12)
	var items := [["Resume", _resume_pause], ["Save Game", _manual_save], ["How to Play", _review_tutorial], ["Restart Tutorial" if tutorial_entry else "Restart (replaces save)", _restart_from_pause.bind(true)], ["Exit Tutorial" if tutorial_entry else "Return to Main Menu", _restart_from_pause.bind(false)], ["Quit Game", func(): get_tree().quit()]]
	for index in range(items.size()):
		var button := Button.new()
		button.text = items[index][0]
		button.custom_minimum_size = Vector2(210, 20)
		button.add_theme_font_size_override("font_size", 9)
		button.pressed.connect(items[index][1])
		choices.add_child(button)
		if index == 0:
			pause_panel.set_meta("initial_focus", button)
		if index == 1:
			save_button = button
	save_status = _hud_text(choices, "", Vector2.ZERO, 7)
	save_status.custom_minimum_size.x = 210
	save_status.autowrap_mode = TextServer.AUTOWRAP_WORD_SMART


func _open_pause() -> void:
	detail_controller.call("exit_navigation")
	if transitioning or loop_panel.visible:
		return
	ApartmentAudio.play_ui("menu")
	pause_panel.show()
	var reason := SaveStore.safe_reason(true)
	save_button.disabled = not reason.is_empty()
	save_status.text = reason
	get_node("../Player").interaction_prompt.hide()
	get_node("../TipTop").clear_monologue()
	get_node("../TipTop").action_label.hide()
	get_tree().paused = true
	var resume_button: Button = pause_panel.get_meta("initial_focus")
	resume_button.grab_focus.call_deferred()


func _review_tutorial() -> void:
	# Replayable interactive lessons are main-menu-only. In-game help reviews
	# rules without clearing campaign tutorial flags or starting spotlights.
	pause_panel.hide()
	rules_review = true
	rules_intro.call("open", true)


func request_rest() -> void:
	if tutorial.call("warn_before_sleep"):
		return
	GameState.end_day()


func _resume_pause() -> void:
	ApartmentAudio.play_ui("resume")
	pause_panel.hide()
	_restore_modal_pause()
	get_viewport().gui_release_focus()


func _restart_from_pause(play_now: bool) -> void:
	var selected := GameState.difficulty
	if not play_now and SaveStore.safe_reason(true).is_empty():
		SaveStore.save_campaign(true)
	GameState.restart()
	if play_now:
		SaveStore.new_campaign(tutorial_entry)
		GameState.select_difficulty(selected)
		get_tree().set_meta("restart_playing", true)
		if tutorial_entry:
			get_tree().set_meta("tutorial_entry", true)
	# Keep the autoload clock stopped until the destination is ready.
	get_tree().paused = true
	if play_now:
		get_tree().reload_current_scene()
	else:
		get_tree().change_scene_to_file("res://scenes/title.tscn")


func hud_navigation_active() -> bool:
	return is_instance_valid(detail_controller) and bool(detail_controller.get("keyboard_navigation")) and bool(detail_controller.call("_allowed"))


func _input(event: InputEvent) -> void:
	if SaveStore.loading:
		get_viewport().set_input_as_handled()
		return
	if _rules_open():
		if event is InputEventKey and (event.is_action("interact") or event.keycode in [KEY_ENTER, KEY_KP_ENTER]):
			# Enter on Back should activate Back; E always advances the page.
			var focused: Control = get_viewport().gui_get_focus_owner()
			if event.is_action("interact") or focused != rules_intro.get("back"):
				if event.pressed and not event.echo:
					rules_intro.call("advance")
				get_viewport().set_input_as_handled()
		elif event.is_action("ui_cancel"):
			get_viewport().set_input_as_handled()
		return
	if _eject_open():
		if event.is_action_pressed("ui_cancel"):
			_close_eject()
			get_viewport().set_input_as_handled()
		elif event.is_action("interact"):
			get_viewport().set_input_as_handled()
		return
	if is_instance_valid(showcase) and event is InputEventKey and event.echo:
		get_viewport().set_input_as_handled()
		return
	if is_instance_valid(showcase) and event.is_action_pressed("ui_cancel"):
		get_viewport().set_input_as_handled()
		return
	if event is InputEventKey and event.pressed and not event.echo and event.keycode == KEY_TAB and detail_controller.call("_allowed"):
		detail_controller.call("toggle_navigation")
		get_viewport().set_input_as_handled()
		return
	if hud_navigation_active() and not event.is_action("ui_cancel"):
		if event.is_action("interact"):
			get_viewport().set_input_as_handled()
		return
	if is_instance_valid(tutorial) and tutorial.call("handle_input", event):
		get_viewport().set_input_as_handled()
		return
	if event is InputEventKey and event.pressed and not event.echo and event.keycode == KEY_ESCAPE:
		get_viewport().set_input_as_handled()
		if transitioning:
			return
		if _pause_open():
			_resume_pause()
		elif repair_panel.visible:
			_close_repair_menu()
		elif _household_open():
			household_panel.hide()
			household_panel.queue_free()
			_restore_modal_pause()
		else:
			_open_pause()
		return
	if _pause_open():
		if event.is_action("interact"):
			get_viewport().set_input_as_handled()
		return
	if transitioning:
		get_viewport().set_input_as_handled()
		return
	if repair_panel.visible:
		if event.is_action_pressed("ui_cancel"):
			_close_repair_menu()
			get_viewport().set_input_as_handled()
		elif event.is_action_pressed("interact"):
			get_viewport().set_input_as_handled()
		return
	if event is InputEventKey and not get_tree().paused and not get_node("../Player").animation_busy:
		for action in ["move_up", "move_down", "move_left", "move_right"]:
			if event.is_action(action):
				# Polling Input still moves Judy; GUI focus navigation gets no arrow.
				get_viewport().set_input_as_handled()
				return
	if GameState.research_active:
		# Research buttons keep mouse input; no hidden comic captures E/Enter.
		return
	if not dialogue_overlay.visible:
		return
	if event is InputEventKey:
		get_viewport().set_input_as_handled()
		if event.pressed and not event.echo and (event.is_action_pressed("interact") or event.keycode == KEY_ENTER or event.keycode == KEY_KP_ENTER):
			if dialogue_text.visible_characters < dialogue_text.get_total_character_count():
				dialogue_text.visible_characters = dialogue_text.get_total_character_count()
				reveal_characters = dialogue_text.get_total_character_count()
			else:
				_advance_dialogue()


func _advance_dialogue() -> void:
	if not _comic_safe():
		return
	if dialogue_lines.is_empty():
		dialogue_overlay.hide()
		active_dialogue_event = ""
		if is_instance_valid(showcase):
			showcase.call("finish_dialogue")
		if dialogue_resume_loop:
			loop_panel.show()
			dialogue_resume_loop = false
		_sync_overlay_visibility()
		last_portrait = ""
		_restore_modal_pause()
		if sleep_dialogue_pending:
			sleep_dialogue_pending = false
			_play_day_transition()
		return
	if not dialogue_overlay.visible:
		dialogue_resume_loop = loop_panel.visible
		loop_panel.hide()
	var line: Array = dialogue_lines.pop_front()
	ApartmentAudio.play_ui("page")
	active_dialogue_event = str(line[4]) if line.size() > 4 else ""
	if line[0] == "Judy" and line.size() > 3 and not str(line[3]).is_empty():
		line[1] = GameState.judy_response(line[3])
		line[2] = "happy" if GameState.mood >= 70 else ("neutral" if GameState.mood >= 45 else "annoyed")
	dialogue_speaker.text = line[0]
	_present_speaker(line[0], line[2] if line.size() > 2 else "neutral")
	var pages := _dialogue_pages(line[1])
	for index in range(pages.size() - 1, 0, -1):
		dialogue_lines.push_front([line[0], pages[index], line[2] if line.size() > 2 else "neutral", "", active_dialogue_event])
	dialogue_text.text = _dialogue_line_breaks(pages[0])
	dialogue_text.size = dialogue_bounds
	reveal_characters = 0.0
	dialogue_text.visible_characters = 0
	get_node("../TipTop").clear_monologue()
	get_node("../TipTop").action_label.hide()
	get_node("../Player").interaction_prompt.hide()
	notification_panel.hide()
	system_notice.hide()
	dialogue_overlay.show()
	get_tree().paused = true


func _dialogue_pages(text: String) -> Array[String]:
	var sentences := RegEx.new()
	sentences.compile("[^.!?]+[.!?]+[\"')]*|[^.!?]+$")
	var pages: Array[String] = []
	var page := ""
	for match_result in sentences.search_all(text):
		var sentence: String = match_result.get_string().strip_edges()
		if sentence.is_empty():
			continue
		var candidate := sentence if page.is_empty() else page + " " + sentence
		if _dialogue_fits(candidate):
			page = candidate
			continue
		if not page.is_empty():
			pages.append(page)
			page = ""
		if _dialogue_fits(sentence):
			page = sentence
			continue
		# A sentence taller than the panel needs continuation. Prefer a clause
		# ending, then a word boundary; every remaining word stays in the queue.
		var words := sentence.replace("\n", " ").split(" ", false)
		while not words.is_empty():
			var count := 1
			while count < words.size() and _dialogue_fits(" ".join(words.slice(0, count + 1))):
				count += 1
			if count < words.size():
				for index in range(count - 1, 0, -1):
					var word: String = words[index]
					if word.ends_with(",") or word.ends_with(";") or word.ends_with(":") or word.ends_with("—"):
						count = index + 1
					break
			var fragment := " ".join(words.slice(0, count))
			words = words.slice(count)
			if words.is_empty():
				page = fragment
			else:
				pages.append(fragment)
	if not page.is_empty():
		pages.append(page)
	if pages.is_empty():
		pages.append(text)
	return pages


func _dialogue_line_breaks(text: String) -> String:
	var font := dialogue_text.get_theme_font("font")
	var font_size := dialogue_text.get_theme_font_size("font_size")
	var rows: Array[String] = []
	for paragraph in text.split("\n"):
		var row := ""
		for word in paragraph.split(" ", false):
			var candidate := word if row.is_empty() else row + " " + word
			if not row.is_empty() and font.get_string_size(candidate, HORIZONTAL_ALIGNMENT_LEFT, -1, font_size).x > dialogue_bounds.x - 4.0:
				rows.append(row)
				row = word
			else:
				row = candidate
		rows.append(row)
	return "\n".join(rows)


func _dialogue_fits(text: String) -> bool:
	var font := dialogue_text.get_theme_font("font")
	var font_size := dialogue_text.get_theme_font_size("font_size")
	var width := dialogue_bounds.x - 4.0
	var rows := 0
	for paragraph in text.split("\n"):
		var row := ""
		for word in paragraph.split(" ", false):
			var candidate := word if row.is_empty() else row + " " + word
			if font.get_string_size(candidate, HORIZONTAL_ALIGNMENT_LEFT, -1, font_size).x > width and not row.is_empty():
				rows += 1
				row = word
			else:
				row = candidate
		rows += 1
	return rows * (ceilf(font.get_height(font_size)) + 1.0) <= dialogue_bounds.y


func _present_speaker(speaker: String, expression: String) -> void:
	var character := speaker.to_lower()
	var known := character in ["judy", "tiptop"]
	var robot := character == "tiptop"
	var panel := dialogue_art.get_parent() as Control
	panel.position = Vector2(60, 236)
	dialogue_art.size = Vector2(224, 54) if robot else Vector2(248, 60)
	dialogue_portrait_frame.scale = Vector2(0.68, 0.68) if robot else Vector2(0.76, 0.76)
	dialogue_hint.position = Vector2(133, 47) if robot else Vector2(153, 53)
	# Keep both characters' labels inside their panel, regardless of text length.
	dialogue_text.autowrap_mode = TextServer.AUTOWRAP_WORD_SMART
	dialogue_text.clip_text = true
	dialogue_art.visible = known
	dialogue_portrait_frame.visible = known
	dialogue_plain.visible = not known
	dialogue_speaker.position = Vector2(90, 8) if known else Vector2(8, 18)
	dialogue_text.position = Vector2(87, 22) if known else Vector2(8, 31)
	dialogue_bounds = Vector2(150, 26) if known else Vector2(232, 20)
	if robot:
		dialogue_speaker.position = Vector2(84, 7)
		dialogue_text.position = Vector2(84, 21)
		dialogue_bounds = Vector2(126, 21)
	if not known:
		last_portrait = ""
		return
	dialogue_art.texture = portrait_cache[character + "_dialogue_panel"]
	dialogue_accent.color = Color("ef4565") if character == "judy" else Color("298ecb")
	dialogue_portrait.texture = portrait_cache.get(character + "_" + expression, portrait_cache[character + "_neutral"])
	var portrait_key := character + "_" + expression
	if portrait_key == last_portrait:
		return
	last_portrait = portrait_key
	if portrait_tween and portrait_tween.is_valid():
		portrait_tween.kill()
	dialogue_portrait.position = Vector2(-4, 0)
	dialogue_portrait.modulate.a = 0.6
	portrait_tween = create_tween().set_pause_mode(Tween.TWEEN_PAUSE_PROCESS).set_parallel()
	portrait_tween.tween_property(dialogue_portrait, "position", Vector2.ZERO, 0.13)
	portrait_tween.tween_property(dialogue_portrait, "modulate:a", 1.0, 0.13)


func _clear_stale_break_reminders() -> void:
	for events in [deferred_story_events, transition_events]:
		for index in range(events.size() - 1, -1, -1):
			if str(events[index]).begins_with("break_reminder_"):
				events.remove_at(index)
	for index in range(dialogue_lines.size() - 1, -1, -1):
		var line: Array = dialogue_lines[index]
		var event_id: String = str(line[4]) if line.size() > 4 else ""
		if event_id.begins_with("break_reminder_") and not (dialogue_overlay.visible and active_dialogue_event == event_id):
			dialogue_lines.remove_at(index)


func _on_story_event(event: String) -> void:
	if event.begins_with("break_reminder_") and GameState.work_streak < 2:
		return
	if event in ["day_2", "day_3"]:
		morning_pending_day = GameState.day
	var optional := event.begins_with("ambient_") or event == "desk_approach"
	if optional and not deferred_story_events.is_empty():
		return
	if not _comic_safe():
		if not optional and not story_seen.has(event) and not deferred_story_events.has(event):
			deferred_story_events.append(event)
		return
	if transitioning:
		transition_events.append(event)
		return
	if event == "proactive_fix":
		_show_feedback("+10% Research — Proactive Fix!")
		return
	if (event.begins_with("ambient_") or event == "desk_approach") and (dialogue_overlay.visible or not dialogue_lines.is_empty() or loop_panel.visible or GameState.notification_active or GameState.day_ended or GameState.game_finished or get_tree().paused):
		return
	if story_seen.has(event):
		return
	story_seen[event] = true
	var lines: Array = []
	match event:
		"desk_approach":
			lines = [["Judy", "Right. Notes, coffee... probably some science in here somewhere."]]
		"opening":
			lines = [["Judy", "Okay, Judy. Three days. Let's make this look like science."], ["TipTop", "I'm TipTop! I handle routines. Usually the right ones."], ["Judy", "Showcase on day three, TipTop. Try to look busy."]]
		"first_tap":
			lines = [["TipTop", "Ideas Flowing Protocol, step 4: Leave tap open. Complete. Proceeding to next objective."], ["Judy", "", "neutral", "chore"]]
		"fixed":
			lines = [["TipTop", "Routine updated: ideas may flow without water. Thank you for teaching me, Judy."], ["Judy", "There we go. Knew you had it in you."]]
		"ambient_1":
			lines = [["TipTop", "I apologize."], ["Judy", "For what?"], ["TipTop", "I have not determined that yet."]]
		"ambient_2":
			lines = [["TipTop", "Thank you, Judy."], ["Judy", "I just moved my chair."], ["TipTop", "Yes. I am checking the connection."]]
		"ambient_3":
			lines = [["TipTop", "That went well. I apologize."], ["Judy", "You can just take the win, buddy."], ["TipTop", "Then the apology may belong to something else."]]
		"day_2":
			lines = [["Judy", "Morning. No dripping. I could get used to this."], ["TipTop", "My new routine agrees."]] if GameState.repairs["sink"] else [["Judy", "Morning. Right, your routine. I still haven't fixed that."], ["TipTop", "I've resumed the flowing-ideas procedure."]]
		"day_3":
			lines = [["TipTop", "Showcase day! My tap routine is ready to do nothing."], ["Judy", "Nice. Now where'd I put my notes?"]] if GameState.repairs["sink"] else [["TipTop", "Showcase day! Shall I demonstrate the water feature?"], ["Judy", "Let's skip that bit, yeah?"]]
		"ending":
			_prepare_showcase()
			if ending_kind == "bad":
				lines = [["Judy", "TipTop. Please tell me that's supposed to happen.", "surprised"], ["TipTop", "According to my latest calculations... no.", "error"], ["Judy", "Great. We'll need another draft.", "annoyed"], ["TipTop", "I can help with the next draft.", "proud"], ["Judy", "I'll take any good news you've got.", "neutral"], ["TipTop", "We are no longer behind schedule.", "proud"]]
			elif ending_kind == "good":
				lines = [["Judy", "Thought we'd run out of time. Couldn't have done this without you, buddy.", "happy"], ["TipTop", "My calculations were only occasionally incorrect.", "proud"], ["Judy", "Occasionally?", "annoyed"], ["TipTop", "They're applauding! Celebration routine ready.", "proud"], ["Judy", "Just bow, buddy. We've earned a dry floor.", "happy"], ["TipTop", "Bow routine confirmed. No water required.", "proud"]]
			else:
				lines = [["Judy", "It wasn't exactly what I planned. Still, we got up here.", "neutral"], ["TipTop", "So the water feature was a success?", "confused"], ["Judy", "That bit wasn't in the demo. Glad you came, though.", "happy"], ["TipTop", "Would you like to schedule a second attempt?", "neutral"], ["Judy", "After a very long nap.", "happy"]]
		_:
			if event.begins_with("break_reminder_"):
				lines = [["TipTop", "Judy, you've completed two long research sessions. My wellness protocol recommends a break.", "worried"], ["Judy", "", "neutral", "break"], ["TipTop", "I shall supervise the apartment while you rest.", "proud"]]
			elif event.begins_with("ignored_"):
				lines = [["Judy", "One more bit of research, then I'll fix it. That's the plan, anyway."], ["TipTop", "No correction received. Current routine must be acceptable!"]]
	# Optional third field: expressions never change the spoken text or outcomes.
	var expression_sets := {
		"opening": ["neutral", "proud", "happy"],
		"first_tap": ["proud", "annoyed"],
		"fixed": ["proud", "happy"],
		"ambient_1": ["worried", "surprised", "confused"],
		"ambient_2": ["neutral", "surprised", "confused"],
		"ambient_3": ["error", "happy", "confused"],
		"day_2": ["happy", "proud"] if GameState.repairs["sink"] else ["annoyed", "proud"],
		"day_3": ["proud", "neutral"] if GameState.repairs["sink"] else ["proud", "annoyed"]
	}
	var selected: Array = expression_sets.get(event, [])
	if event.begins_with("ignored_"):
		selected = ["neutral", "proud"]
	for index in range(mini(lines.size(), selected.size())):
		if lines[index].size() == 2:
			lines[index].append(selected[index])
	if event.begins_with("break_reminder_"):
		for line in lines:
			while line.size() < 4:
				line.append("")
			line.append(event)
	var already_open := dialogue_overlay.visible
	dialogue_lines.append_array(lines)
	if not already_open and not dialogue_lines.is_empty():
		_advance_dialogue()


func _manual_save() -> void:
	if SaveStore.save_campaign(true):
		save_status.text = "Game saved."
	else:
		save_status.text = SaveStore.last_error
