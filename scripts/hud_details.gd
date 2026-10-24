extends Node

# Presentation only: never pauses the world or changes game-state values.
var hud: CanvasLayer
var buttons: Dictionary
var groups: Dictionary
var panel: PanelContainer
var sidebar: Control
var active := ""
var pinned := ""
var dismissed := ""
var leave_time := 0.0
var reference_height := 288.0


func setup(owner_hud: CanvasLayer, targets: Dictionary, pages: Dictionary, popup: PanelContainer, column: Control, height: float) -> void:
	hud = owner_hud
	buttons = targets
	groups = pages
	panel = popup
	sidebar = column
	reference_height = height
	for button in buttons.values():
		var category: String = button.get_meta("details_category")
		button.toggle_mode = true
		button.pressed.connect(_toggle.bind(category))
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


func _allowed() -> bool:
	return not get_tree().paused and not GameState.game_finished and not GameState.day_ended and not GameState.notification_active and not hud.get("transitioning") and not hud.get("dialogue_overlay").visible and not hud.get("loop_panel").visible and not hud.get("repair_panel").visible and not hud.call("_household_open")


func _process(delta: float) -> void:
	if not is_instance_valid(panel):
		return
	if not _allowed():
		panel.hide()
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
	var panel_focus: bool = is_instance_valid(focused) and panel.is_ancestor_of(focused)
	if hover != dismissed and focus != dismissed:
		dismissed = ""
	var requested := hover if not hover.is_empty() else (active if inside or panel_focus else focus)
	if not requested.is_empty() and requested != dismissed:
		active = requested
		leave_time = 0.0
	elif not pinned.is_empty():
		active = pinned
	elif requested.is_empty() or requested == dismissed:
		leave_time += delta
		# A small crossing grace period bridges the gap from icon to panel.
		if leave_time >= 0.18:
			active = ""
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
