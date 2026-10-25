extends Node

# Presentation only: never pauses the world or changes game-state values.
var hud: CanvasLayer
var buttons: Dictionary
var groups: Dictionary
var panel: PanelContainer
var sidebar: Control
var active := ""
var pinned := "repairs"
var dismissed := ""
var leave_time := 0.0
var reference_height := 288.0
var caption: Label
var gutter: Control
var keyboard_navigation := false
const NAMES := {"research": "Research", "repairs": "TipTop", "time": "Time Usage", "needs": "Needs"}


func setup(owner_hud: CanvasLayer, targets: Dictionary, pages: Dictionary, popup: PanelContainer, column: Control, height: float, label_gutter: Control) -> void:
	hud = owner_hud
	buttons = targets
	groups = pages
	panel = popup
	sidebar = column
	reference_height = height
	gutter = label_gutter
	caption = Label.new()
	caption.add_theme_font_size_override("font_size", 6)
	caption.add_theme_color_override("font_color", Color("eadbc0"))
	caption.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
	caption.mouse_filter = Control.MOUSE_FILTER_IGNORE
	gutter.add_child(caption)
	caption.hide()
	for button in buttons.values():
		var category: String = button.get_meta("details_category")
		button.toggle_mode = true
		button.focus_mode = Control.FOCUS_NONE
		button.pressed.connect(_toggle.bind(category))
	exit_navigation()
	panel.hide()


func _toggle(category: String) -> void:
	if not _allowed():
		return
	if pinned == category:
		pinned = ""
		active = ""
		dismissed = category
	else:
		pinned = category
		active = category
		dismissed = ""
	leave_time = 0.0
	SaveStore.request_autosave("hud_pin")


func restore_pin(category: String) -> void:
	pinned = category if category in groups or category.is_empty() else "repairs"
	active = pinned
	dismissed = ""
	leave_time = 0.0


func _allowed() -> bool:
	return not get_tree().paused and not GameState.game_finished and not GameState.day_ended and not GameState.notification_active and not GameState.research_active and GameState.personal_activity.is_empty() and not GameState.household_busy and not GameState.repair_in_progress and not hud.get_node("../Player").get("animation_busy") and not hud.get("transitioning") and not hud.get("dialogue_overlay").visible and not hud.get("loop_panel").visible and not hud.get("repair_panel").visible and not hud.call("_household_open") and not hud.call("_eject_open")


func toggle_navigation() -> void:
	if keyboard_navigation:
		exit_navigation()
	elif _allowed():
		keyboard_navigation = true
		for button in buttons.values():
			button.focus_mode = Control.FOCUS_ALL
		panel.get_child(0).focus_mode = Control.FOCUS_ALL
		buttons["research"].grab_focus()


func exit_navigation() -> void:
	keyboard_navigation = false
	var focused: Control = hud.get_viewport().gui_get_focus_owner()
	if is_instance_valid(focused) and (focused in buttons.values() or panel.is_ancestor_of(focused)):
		hud.get_viewport().gui_release_focus()
	for button in buttons.values():
		button.focus_mode = Control.FOCUS_NONE
	panel.get_child(0).focus_mode = Control.FOCUS_NONE


func _process(delta: float) -> void:
	if not is_instance_valid(panel):
		return
	var allowed := _allowed()
	for button in buttons.values():
		button.disabled = not allowed
		button.modulate = Color.WHITE if allowed else Color(1, 1, 1, 0.45)
	if not allowed:
		exit_navigation()
		panel.hide()
		caption.hide()
		return
	var hover := ""
	var focus := ""
	var focused: Control = hud.get_viewport().gui_get_focus_owner()
	for button in buttons.values():
		var category: String = button.get_meta("details_category")
		button.set_pressed_no_signal(pinned == category)
		if button.get_global_rect().has_point(button.get_global_mouse_position()):
			hover = category
		if focused == button:
			focus = category
	var inside: bool = panel.visible and panel.get_global_rect().has_point(panel.get_global_mouse_position())
	if panel.visible and not active.is_empty():
		var tab: Control = buttons[active]
		var tab_rect := tab.get_global_rect()
		var bridge := Rect2(Vector2(sidebar.get_global_rect().position.x, tab_rect.end.y), Vector2(96, maxf(0, panel.get_global_rect().position.y - tab_rect.end.y)))
		inside = inside or bridge.has_point(panel.get_global_mouse_position())
	var panel_focus: bool = is_instance_valid(focused) and panel.is_ancestor_of(focused)
	if hover != dismissed and focus != dismissed:
		dismissed = ""
	var requested := hover if not hover.is_empty() else (active if inside or panel_focus else focus)
	# Hover/focus previews are temporary; leaving restores the pinned checklist.
	if not requested.is_empty() and requested != dismissed:
		active = requested
		leave_time = 0.0
	elif requested.is_empty() or requested == dismissed:
		leave_time += delta
		# A small crossing grace period bridges the gap from icon to panel.
		if leave_time >= 0.18:
			active = pinned
	var label_category := hover if not hover.is_empty() else (focus if not focus.is_empty() else pinned)
	caption.visible = not label_category.is_empty()
	if caption.visible:
		caption.text = NAMES[label_category]
		var icon: Control = buttons[label_category]
		var center: Vector2 = gutter.get_global_transform().affine_inverse() * icon.get_global_rect().get_center()
		var label_width := caption.get_theme_font("font").get_string_size(caption.text, HORIZONTAL_ALIGNMENT_LEFT, -1, 6).x + 4
		caption.size = Vector2(label_width, 12)
		caption.position = Vector2(clampf(center.x - label_width * 0.5, 0, 96 - label_width), 0).round()
	panel.visible = not active.is_empty()
	for category in groups:
		groups[category].visible = category == active
	if not panel.visible:
		return
	var body: Control = groups[active]
	var top := sidebar.position.y + sidebar.get_combined_minimum_size().y + 4
	panel.position = Vector2(sidebar.position.x, top)
	var available := maxf(24, reference_height - top - 5)
	panel.size = Vector2(96, minf(available, body.get_combined_minimum_size().y + 12))
