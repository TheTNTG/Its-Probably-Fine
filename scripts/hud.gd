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
var tiptop_talk_count := 0


func _household_open() -> bool:
	return is_instance_valid(household_panel) and household_panel.visible


func _comic_safe() -> bool:
	return not GameState.research_active and not get_node("../Player").animation_busy and not transitioning and not repair_panel.visible and not _household_open()


func overhead_thoughts_allowed() -> bool:
	return not dialogue_overlay.visible and not repair_panel.visible and not loop_panel.visible and not notification_panel.visible and not transitioning and not _household_open() and not GameState.day_ended and not GameState.game_finished


func _restore_modal_pause() -> void:
	get_tree().paused = dialogue_overlay.visible or repair_panel.visible or loop_panel.visible or _household_open() or transitioning or GameState.day_ended or GameState.game_finished


func research_choices() -> void:
	if GameState.research_active or get_node("../Player").animation_busy:
		return
	if GameState.work_sessions_remaining <= 0:
		_show_feedback("Too exhausted to work. Rest until tomorrow.")
		return
	if not GameState.research_available():
		if GameState.has_research_time():
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
		[["TipTop", "Are we ready for the showcase?", "worried"], ["Judy", "We've got results. Now I just have to explain them." if GameState.research_progress >= 80 else "Getting there. My notes are starting to look suspiciously useful.", "happy"], ["TipTop", "I shall provide supportive hovering.", "proud"]]
	]
	# A direct conversation takes priority without dropping queued story lines.
	dialogue_lines = pools[tiptop_talk_count % pools.size()].duplicate(true) + dialogue_lines
	tiptop_talk_count += 1
	_advance_dialogue()


func set_research_controls(active: bool) -> void:
	research_strip.visible = active
	notification_panel.hide()
	if active:
		pending_feedback.clear()


func _fast_forward_research() -> void:
	if GameState.research_active:
		var judy = get_node("../Player")
		judy.research_fast_forward = not judy.research_fast_forward
		GameState.research_playback_rate = 6.0 if judy.research_fast_forward else 1.0


func _skip_research() -> void:
	if get_tree().paused or not GameState.research_active:
		return
	var remaining := GameState.research_duration - GameState.research_elapsed - GameState.research_accumulator
	if remaining > 0.0:
		# Preserve scheduled chores, messes and mosquitoes; the player animation
		# handles standing up and awarding the session exactly once afterward.
		GameState.advance_research(remaining)


func household_choices(location: String) -> void:
	if is_instance_valid(household_panel) or transitioning or dialogue_overlay.visible or repair_panel.visible or loop_panel.visible or GameState.research_active:
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
		var duration := GameState.research_session_minutes()
		var watch_minutes := duration / GameState.RESEARCH_MINUTES * GameState.WATCH_REAL_SECONDS / 60.0
		options.append(["Watch Research (%d min; ~%.1f real min)" % [duration, watch_minutes], judy._research_animation.bind(false)])
		options.append(["Fast-forward (%d min; 6x playback)" % duration, judy._research_animation.bind(true)])
	elif location == "bookshelf":
		options.append(["Organize books myself — 20 min", judy.organize_for_research])
	elif location == "tiptop":
		options.append(["Talk to TipTop", talk_to_tiptop])
		if not GameState.tiptop_fixed:
			options.append(["Repair TipTop...", GameState.fix_tap])
	elif GameState.needs_cleanup(location):
		options.append(["Clean %s myself — %d min" % [location, GameState.CLEAN_COSTS[location]], judy._clean_animation.bind(location)])
	if GameState.mosquito_level > 0 and location != "research":
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
	GameState.mosquito_task = true
	GameState.state_changed.emit()
	_show_feedback("TipTop: Mosquito removal requested. On my way!")


func _ready() -> void:
	process_mode = Node.PROCESS_MODE_ALWAYS
	_build_loop_ui()
	_build_dialogue_ui()
	_build_transition_ui()
	_build_repair_menu()
	_build_system_notice()
	_build_research_controls()
	_fit_screen_ui()
	get_viewport().size_changed.connect(_fit_screen_ui)
	_smooth_ui_text(self)
	GameState.state_changed.connect(_update_hud)
	GameState.malfunction_triggered.connect(_show_malfunction)
	GameState.story_event.connect(_on_story_event)
	GameState.repair_menu_requested.connect(_open_repair_menu)
	GameState.action_feedback.connect(_show_feedback)
	_update_hud()
	if get_tree().has_meta("new_game_slide"):
		get_tree().remove_meta("new_game_slide")
		_reveal_new_game()


func _fit_screen_ui() -> void:
	# Fit a reference canvas uniformly, retaining safe margins at any aspect ratio.
	var screen := get_viewport().get_visible_rect().size
	var reference := Vector2(384, 288)
	var factor := minf(screen.x / reference.x, screen.y / reference.y)
	transform = Transform2D(0.0, Vector2(factor, factor), 0.0, (screen - reference * factor) * 0.5)
	(transition_cover.get_parent() as CanvasLayer).transform = transform
	if is_instance_valid(repair_panel):
		repair_panel.position = -transform.origin / factor
		repair_panel.size = screen / factor
	if is_instance_valid(household_panel):
		# Include any aspect-ratio margins in the dimmer; center its contents
		# against the visible screen, independently of the camera.
		household_panel.position = -transform.origin / factor
		household_panel.size = screen / factor


func _smooth_ui_text(node: Node) -> void:
	if node is Control:
		node.texture_filter = CanvasItem.TEXTURE_FILTER_NEAREST if node.has_meta("dialogue_pixel_art") else CanvasItem.TEXTURE_FILTER_LINEAR
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


func _update_hud() -> void:
	if not GameState.notification_active and fix_button.visible:
		notification_panel.hide()
	day_label.text = "Day %d" % GameState.day
	_update_clock_hud()
	research_label.text = "Research: %d%%" % GameState.research_progress
	sessions_label.text = "Work sessions: %d / 4" % GameState.work_sessions_remaining
	weekday_label.text = ["Monday", "Tuesday", "Wednesday"][clampi(GameState.day - 1, 0, 2)]
	overview_bar.value = GameState.research_progress
	if (GameState.day_ended or GameState.game_finished) and not GameState.research_active:
		notification_panel.hide()
		get_node("../TipTop").prepare_for_sleep()
		get_tree().paused = true
		loop_panel.show()
		if GameState.game_finished:
			loop_button.text = "Restart"
			if GameState.research_progress >= 80 and GameState.tiptop_fixed:
				loop_message.text = "Good ending — It's probably fine!\nResearch: %d%%\nAll routines repaired." % GameState.research_progress
			elif GameState.research_progress >= 80:
				loop_message.text = "Bittersweet ending\nResearch: %d%%\nSome routines remain faulty." % GameState.research_progress
			else:
				loop_message.text = "A work in progress\nResearch: %d%% — below the 80%% goal." % GameState.research_progress
		else:
			loop_message.text = "Day %d complete — 8:00 PM\nResearch: %d%%\nShowcase deadline: Day 3, 8:00 PM" % [GameState.day, GameState.research_progress]
			loop_button.text = "Showcase" if GameState.day == 3 else "Next day"


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
	var progress_card := _hud_card(Rect2(314, 4, 65, 16))
	progress_card.clip_contents = true
	var flask := Polygon2D.new()
	flask.polygon = PackedVector2Array([Vector2(5, 3), Vector2(9, 3), Vector2(9, 7), Vector2(12, 12), Vector2(3, 12), Vector2(6, 7), Vector2(6, 3)])
	flask.color = Color("80afbb")
	progress_card.add_child(flask)
	research_label.position = Vector2(329, 5)
	research_label.size = Vector2(46, 7)
	research_label.add_theme_font_size_override("font_size", 5)
	research_label.horizontal_alignment = HORIZONTAL_ALIGNMENT_LEFT
	overview_bar = ProgressBar.new()
	overview_bar.position = Vector2(15, 10)
	overview_bar.size = Vector2(45, 3)
	overview_bar.show_percentage = false
	_style_thin_bar(overview_bar)
	overview_bar.size = Vector2(45, 3)
	var fill := StyleBoxFlat.new()
	fill.bg_color = Color("639dad")
	fill.set_corner_radius_all(1)
	overview_bar.add_theme_stylebox_override("fill", fill)
	progress_card.add_child(overview_bar)
	var deadline_card := _hud_card(Rect2(314, 23, 65, 17))
	_hud_text(deadline_card, "Showcase deadline", Vector2(5, 2), 5)
	_hud_text(deadline_card, "Day 3, 8:00 PM", Vector2(5, 9), 6)
	var controls := _hud_card(Rect2(5, 242, 48, 38))
	var controls_text := _hud_text(controls, "E   Interact\nI    Inventory\nTab Menu", Vector2(4, 3), 6)
	controls_text.add_theme_constant_override("line_spacing", 0)
	_hud_card(Rect2(300, 273, 79, 11))
	sessions_label = _hud_text(self, "", Vector2(304, 274), 6)
	loop_panel = ColorRect.new()
	loop_panel.position = Vector2(42, 70)
	loop_panel.size = Vector2(300, 112)
	loop_panel.color = Color(0.08, 0.08, 0.12, 0.98)
	add_child(loop_panel)
	loop_message = Label.new()
	loop_message.position = Vector2(8, 8)
	loop_message.size = Vector2(284, 66)
	loop_message.add_theme_font_size_override("font_size", 8)
	loop_message.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
	loop_message.autowrap_mode = TextServer.AUTOWRAP_WORD_SMART
	loop_message.text = "Day 3 showcase: reach 80% and repair all routines.\nE to interact. Make the bed before resting.\n4 sessions/day: +10%/120 min; tap: +5%/160 min.\nFull sessions must fit before 8:00 PM."
	loop_panel.add_child(loop_message)
	loop_button = Button.new()
	loop_button.position = Vector2(100, 80)
	loop_button.size = Vector2(100, 24)
	loop_button.add_theme_font_size_override("font_size", 8)
	loop_button.text = "Start"
	loop_button.pressed.connect(_on_loop_pressed)
	loop_panel.add_child(loop_button)
	get_tree().paused = true


func _on_loop_pressed() -> void:
	if transitioning or get_node("../Player").animation_busy:
		return
	if GameState.game_finished:
		_play_day_transition(true)
		return
	if GameState.day_ended:
		_play_day_transition()
		return
	loop_panel.hide()
	get_tree().paused = false
	if not story_seen.has("opening"):
		morning_pending_day = GameState.day
		_on_story_event("opening")


func _build_transition_ui() -> void:
	var transition_layer := CanvasLayer.new()
	transition_layer.layer = 128
	add_child(transition_layer)
	transition_cover = ColorRect.new()
	transition_cover.color = Color.BLACK
	transition_cover.size = Vector2(384, 288)
	transition_cover.hide()
	transition_layer.add_child(transition_cover)
	transition_title = Label.new()
	transition_title.position = Vector2(0, 132)
	transition_title.size = Vector2(384, 24)
	transition_title.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
	transition_title.add_theme_font_size_override("font_size", 14)
	transition_title.texture_filter = CanvasItem.TEXTURE_FILTER_LINEAR
	transition_cover.add_child(transition_title)


func _play_day_transition(restarting := false) -> void:
	if transitioning or (not restarting and not GameState.day_ended):
		return
	transitioning = true
	loop_button.disabled = true
	get_tree().paused = true
	transition_title.hide()
	if not restarting:
		loop_panel.hide()
		get_node("../TipTop").say_goodnight()
		await get_node("../Player").play_sleep_animation()
	transition_cover.position = Vector2(-384, 0)
	transition_cover.show()
	var wipe := create_tween().set_pause_mode(Tween.TWEEN_PAUSE_PROCESS)
	wipe.set_trans(Tween.TRANS_SINE).set_ease(Tween.EASE_IN_OUT)
	wipe.tween_property(transition_cover, "position:x", 0.0, 0.65)
	await wipe.finished
	get_node("../TipTop").clear_monologue()
	if restarting:
		get_tree().set_meta("new_game_slide", true)
		GameState.restart()
		get_tree().reload_current_scene()
		return
	loop_panel.hide()
	# Advance once, under full black; story dialogue is deferred until reveal.
	GameState.continue_day()
	get_node("../Player").wake_from_bed()
	transition_title.text = "Showcase" if GameState.game_finished else "Day %d" % GameState.day
	transition_title.show()
	await get_tree().create_timer(0.45).timeout
	transition_title.hide()
	var reveal := create_tween().set_pause_mode(Tween.TWEEN_PAUSE_PROCESS)
	reveal.set_trans(Tween.TRANS_SINE).set_ease(Tween.EASE_IN_OUT)
	reveal.tween_property(transition_cover, "position:x", 384.0, 0.65)
	await reveal.finished
	transition_cover.hide()
	loop_button.disabled = false
	transitioning = false
	var events := transition_events.duplicate()
	transition_events.clear()
	for event in events:
		_on_story_event(event)
	get_tree().paused = dialogue_overlay.visible or loop_panel.visible or GameState.day_ended or GameState.game_finished


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
	reveal.tween_property(transition_cover, "position:x", 384.0, 0.65)
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
	for chore in GameState.REPAIR_COSTS:
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
		button.disabled = fixed
		button.text = "%s — %s (%d min)" % ["Water / sink" if chore == "sink" else chore.capitalize(), "Repaired" if fixed else "Faulty", GameState.REPAIR_COSTS[chore]]
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
	_sync_overlay_visibility()
	if GameState.research_active:
		var shown := minf(GameState.research_duration, GameState.research_elapsed + GameState.research_accumulator)
		research_bar.max_value = GameState.research_duration
		research_bar.value = shown
		research_speed_button.text = "Watch 1x" if GameState.research_playback_rate > 1.0 else "Speed 6x"
		research_status.text = "Research: %d / %d min%s" % [int(GameState.research_elapsed), GameState.research_duration, "  Swat!" if GameState.research_interruptions > 0 and fmod(GameState.research_elapsed, 5.0) < 0.25 else ""]
	if transitioning or repair_panel.visible or (is_instance_valid(household_panel) and household_panel.visible):
		return
	if _comic_safe() and not dialogue_overlay.visible:
		if not deferred_story_events.is_empty():
			_on_story_event(deferred_story_events.pop_front())
		elif not dialogue_lines.is_empty():
			_advance_dialogue()
	if morning_pending_day == GameState.day and _comic_safe() and overhead_thoughts_allowed() and not GameState.notification_active:
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
	research_strip.size = Vector2(248, 26)
	research_strip.color = Color("29272d")
	research_strip.hide()
	add_child(research_strip)
	research_status = Label.new()
	research_status.position = Vector2(6, 2)
	research_status.add_theme_font_size_override("font_size", 7)
	research_strip.add_child(research_status)
	research_bar = ProgressBar.new()
	research_bar.position = Vector2(6, 16)
	research_bar.size = Vector2(138, 5)
	research_bar.show_percentage = false
	_style_thin_bar(research_bar)
	research_bar.size = Vector2(138, 5)
	research_bar.mouse_filter = Control.MOUSE_FILTER_IGNORE
	research_strip.add_child(research_bar)
	var skip := Button.new()
	research_speed_button = skip
	skip.position = Vector2(148, 3)
	skip.size = Vector2(54, 20)
	skip.text = "Speed 6x"
	skip.add_theme_font_size_override("font_size", 7)
	skip.pressed.connect(_fast_forward_research)
	research_strip.add_child(skip)
	var skip_time := Button.new()
	skip_time.position = Vector2(204, 3)
	skip_time.size = Vector2(40, 20)
	skip_time.text = "Skip"
	skip_time.add_theme_font_size_override("font_size", 7)
	skip_time.pressed.connect(_skip_research)
	research_strip.add_child(skip_time)


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
	if dialogue_overlay.visible:
		get_node("../Player").interaction_prompt.hide()
		get_node("../TipTop").monologue_label.hide()
		get_node("../TipTop").action_label.hide()
	var blocked := dialogue_overlay.visible or repair_panel.visible or transitioning or loop_panel.visible or GameState.research_active or (is_instance_valid(household_panel) and household_panel.visible)
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


func _input(event: InputEvent) -> void:
	if event is InputEventKey and event.pressed and not event.echo and event.keycode in [KEY_I, KEY_TAB] and not get_tree().paused and not GameState.research_active and not get_node("../Player").animation_busy:
		loop_message.text = "Inventory\nNo carried items. Household repairs and cleanup are available at each fixture." if event.keycode == KEY_I else "Apartment menu\nE: interact near furniture or TipTop.\nFour research sessions each day. Make the bed to rest.\nShowcase: Day 3 at 8:00 PM."
		loop_button.text = "Resume"
		loop_panel.show()
		get_tree().paused = true
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
		if dialogue_resume_loop:
			loop_panel.show()
			dialogue_resume_loop = false
		_sync_overlay_visibility()
		last_portrait = ""
		_restore_modal_pause()
		return
	if not dialogue_overlay.visible:
		dialogue_resume_loop = loop_panel.visible
		loop_panel.hide()
	var line: Array = dialogue_lines.pop_front()
	dialogue_speaker.text = line[0]
	_present_speaker(line[0], line[2] if line.size() > 2 else "neutral")
	var pages := _dialogue_pages(line[1])
	for index in range(pages.size() - 1, 0, -1):
		dialogue_lines.push_front([line[0], pages[index], line[2] if line.size() > 2 else "neutral"])
	dialogue_text.text = pages[0]
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
	var font := dialogue_text.get_theme_font("font")
	var font_size := dialogue_text.get_theme_font_size("font_size")
	var width := dialogue_bounds.x - 4.0
	var rows: Array[String] = []
	for paragraph in text.split("\n"):
		var row := ""
		for word in paragraph.split(" ", false):
			var candidate := word if row.is_empty() else row + " " + word
			if font.get_string_size(candidate, HORIZONTAL_ALIGNMENT_LEFT, -1, font_size).x > width and not row.is_empty():
				rows.append(row)
				row = ""
			for character in word:
				var fragment := row + character
				if font.get_string_size(fragment, HORIZONTAL_ALIGNMENT_LEFT, -1, font_size).x > width and not row.is_empty():
					rows.append(row)
					row = ""
				row += character
			row += " "
		rows.append(row.strip_edges())
	var per_page := maxi(1, int(dialogue_bounds.y / (ceilf(font.get_height(font_size)) + 1.0)))
	var pages: Array[String] = []
	for start in range(0, rows.size(), per_page):
		pages.append("\n".join(rows.slice(start, start + per_page)))
	if pages.is_empty():
		pages.append("")
	return pages


func _present_speaker(speaker: String, expression: String) -> void:
	var character := speaker.to_lower()
	var known := character in ["judy", "tiptop"]
	var robot := character == "tiptop"
	var panel := dialogue_art.get_parent() as Control
	panel.position = Vector2(60, 236)
	dialogue_art.size = Vector2(224, 54) if robot else Vector2(248, 60)
	dialogue_portrait_frame.scale = Vector2(0.68, 0.68) if robot else Vector2(0.76, 0.76)
	dialogue_hint.position = Vector2(133, 47) if robot else Vector2(153, 53)
	# Prevent the previous line's minimum width from enlarging TipTop's text rect.
	dialogue_text.clip_text = robot
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


func _on_story_event(event: String) -> void:
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
			lines = [["TipTop", "Ideas Flowing Protocol, step 4: Leave tap open. Complete. Proceeding to next objective."], ["Judy", "Oh, you meant actual water. That explains a few things."]]
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
			if GameState.research_progress < 80:
				lines = [["Judy", "Yeah, I needed another day with this. Maybe two."], ["TipTop", "I can help with the next draft."], ["Judy", "Thanks, buddy. Let's start with the title."]]
			elif GameState.tiptop_fixed:
				lines = [["TipTop", "They're applauding! Celebration routine ready."], ["Judy", "Just bow, buddy. We've earned a dry floor."], ["TipTop", "Bow routine confirmed. No water required."]]
			else:
				lines = [["Judy", "They liked it! Though half the questions were about the tap."], ["TipTop", "So the water feature was a success?"], ["Judy", "Okay, your routine goes first tomorrow. Hold me to that."]]
		_:
			if event.begins_with("ignored_"):
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
	elif event == "ending":
		selected = ["neutral", "worried", "happy"] if GameState.research_progress < 80 else (["proud", "happy", "proud"] if GameState.tiptop_fixed else ["happy", "confused", "annoyed"])
	for index in range(mini(lines.size(), selected.size())):
		if lines[index].size() == 2:
			lines[index].append(selected[index])
	var already_open := dialogue_overlay.visible
	dialogue_lines.append_array(lines)
	if not already_open and not dialogue_lines.is_empty():
		_advance_dialogue()
