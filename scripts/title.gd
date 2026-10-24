extends Control

const ART = preload("res://scripts/apartment_visual.gd")
const JUDY = preload("res://assets/characters/judy_walk_48x48_aligned.png")
const TIPTOP = preload("res://assets/characters/tiptop_hover_48x48.png")
const REFERENCE := Vector2(432, 288)
const CREAM := Color("f5e6cd")
const AMBER := Color("e6b369")
var canvas: Control
var main_menu: PanelContainer
var modal: ColorRect
var modal_body: VBoxContainer
var modal_panel: PanelContainer
var new_game_button: Button
var difficulty_buttons: Array[Button] = []
var difficulty_description: Label
var selected_difficulty := 1
var starting := false
var tutorial_start := false
var tiptop_sprite: Sprite2D
var idle_time := 0.0


func _ready() -> void:
	process_mode = Node.PROCESS_MODE_ALWAYS
	# The autoload clock stays paused; this scene contains decorative art only.
	get_tree().paused = true
	GameState.restart()
	for key in ["restart_playing", "new_game_slide", "tutorial_entry"]:
		if get_tree().has_meta(key):
			get_tree().remove_meta(key)
	texture_filter = CanvasItem.TEXTURE_FILTER_LINEAR
	canvas = Control.new()
	canvas.size = REFERENCE
	canvas.texture_filter = CanvasItem.TEXTURE_FILTER_LINEAR
	var screen_layer := CanvasLayer.new()
	add_child(screen_layer)
	screen_layer.add_child(canvas)
	var menu_theme := Theme.new()
	menu_theme.default_font_size = 10
	menu_theme.set_color("font_color", "Label", CREAM)
	for state in ["normal", "hover", "pressed", "focus", "disabled"]:
		var fill := Color("303038") if state == "normal" else Color("494039")
		var border := Color("736052") if state == "normal" else AMBER
		menu_theme.set_stylebox(state, "Button", _style(fill, border, 5))
	for state in ["font_color", "font_hover_color", "font_pressed_color", "font_focus_color"]:
		menu_theme.set_color(state, "Button", CREAM)
	canvas.theme = menu_theme
	var backdrop := ColorRect.new()
	backdrop.color = Color("17191f")
	backdrop.size = REFERENCE
	canvas.add_child(backdrop)
	_build_apartment()
	var title := _label(canvas, "IT'S PROBABLY FINE", 23)
	title.position = Vector2(18, 13)
	title.add_theme_color_override("font_color", AMBER)
	var subtitle := _label(canvas, "Three days. One robot. What could go wrong?", 10)
	subtitle.position = Vector2(20, 46)
	main_menu = PanelContainer.new()
	main_menu.position = Vector2(268, 85)
	main_menu.size = Vector2(146, 165)
	main_menu.add_theme_stylebox_override("panel", _style(Color("23242bef"), Color("8d7154"), 10))
	canvas.add_child(main_menu)
	var choices := VBoxContainer.new()
	choices.add_theme_constant_override("separation", 6)
	main_menu.add_child(choices)
	new_game_button = _button(choices, "New Game", _show_difficulty)
	_button(choices, "How to Play", _show_help)
	_button(choices, "Settings", _show_settings)
	_button(choices, "Quit Game", func(): get_tree().quit())
	_fit_viewport()
	get_viewport().size_changed.connect(_fit_viewport)
	new_game_button.grab_focus.call_deferred()


func _style(fill: Color, border: Color, margin: int) -> StyleBoxFlat:
	var style := StyleBoxFlat.new()
	style.bg_color = fill
	style.border_color = border
	style.set_border_width_all(1)
	style.set_corner_radius_all(5)
	style.content_margin_left = margin
	style.content_margin_right = margin
	style.content_margin_top = margin
	style.content_margin_bottom = margin
	return style


func _label(parent: Node, text: String, font_size: int = 10) -> Label:
	var label := Label.new()
	label.text = text
	label.add_theme_font_size_override("font_size", font_size)
	parent.add_child(label)
	return label


func _button(parent: Node, text: String, action: Callable) -> Button:
	var button := Button.new()
	button.text = text
	button.custom_minimum_size = Vector2(0, 24)
	button.size_flags_horizontal = Control.SIZE_EXPAND_FILL
	button.pressed.connect(action)
	parent.add_child(button)
	return button


func _build_apartment() -> void:
	var apartment := Node2D.new()
	apartment.position = Vector2(-30, 66)
	apartment.y_sort_enabled = true
	canvas.add_child(apartment)
	var fixtures := [
		["floor", Vector2.ZERO, Vector2.ONE, -2],
		["walls", Vector2.ZERO, Vector2.ONE, -1],
		["bed", Vector2(74, 120), Vector2(1.2, 1.45), 0],
		["desk", Vector2(139, 79), Vector2(1.75, 1.5), 0],
		["chair", Vector2(139, 92), Vector2(1.2, 1.2), 0],
		["sink", Vector2(211, 94), Vector2(1.4, 1.8), 0],
		["fridge", Vector2(263, 106), Vector2(1.2, 1.2), 0],
		["bookshelf", Vector2(60, 166), Vector2(1.05, 1.3), 0],
		["coffee_table", Vector2(172, 154), Vector2(1.15, 1.15), 0],
		["counter", Vector2(254, 151), Vector2(1.5, 1.15), 0],
		["plant", Vector2(254, 170), Vector2.ONE, 0],
		["lamp", Vector2(47, 100), Vector2.ONE, 0]]
	for spec in fixtures:
		var fixture := Node2D.new()
		fixture.set_script(ART)
		fixture.set("fixture", spec[0])
		fixture.position = spec[1]
		fixture.scale = spec[2]
		fixture.z_index = spec[3]
		# Art is static here; no chore visuals, clock updates or navigation.
		fixture.process_mode = Node.PROCESS_MODE_DISABLED
		apartment.add_child(fixture)
	var judy := Sprite2D.new()
	judy.texture = JUDY
	judy.hframes = 4
	judy.vframes = 4
	judy.scale = Vector2.ONE * 0.5
	judy.position = Vector2(148, 113)
	judy.texture_filter = CanvasItem.TEXTURE_FILTER_NEAREST
	apartment.add_child(judy)
	tiptop_sprite = Sprite2D.new()
	tiptop_sprite.texture = TIPTOP
	tiptop_sprite.hframes = 4
	tiptop_sprite.scale = Vector2.ONE * 0.375
	tiptop_sprite.position = Vector2(192, 119)
	tiptop_sprite.texture_filter = CanvasItem.TEXTURE_FILTER_NEAREST
	apartment.add_child(tiptop_sprite)


func _fit_viewport() -> void:
	var screen := get_viewport_rect().size
	var ratio := minf(screen.x / REFERENCE.x, screen.y / REFERENCE.y)
	canvas.scale = Vector2.ONE * ratio
	canvas.position = ((screen - REFERENCE * ratio) * 0.5).round()


func _process(delta: float) -> void:
	idle_time += delta
	tiptop_sprite.frame = int(idle_time * 5.0) % 4
	tiptop_sprite.position.y = 119.0 + sin(idle_time * 2.0) * 0.6


func _open_panel(heading: String, width: float = 310) -> void:
	_close_panel(false)
	main_menu.hide()
	modal = ColorRect.new()
	modal.color = Color(0.04, 0.04, 0.06, 0.88)
	canvas.add_child(modal)
	modal.set_anchors_and_offsets_preset(Control.PRESET_FULL_RECT)
	var center := CenterContainer.new()
	modal.add_child(center)
	center.set_anchors_and_offsets_preset(Control.PRESET_FULL_RECT)
	modal_panel = PanelContainer.new()
	modal_panel.custom_minimum_size.x = width
	modal_panel.add_theme_stylebox_override("panel", _style(Color("23242b"), AMBER, 12))
	center.add_child(modal_panel)
	modal_body = VBoxContainer.new()
	modal_body.add_theme_constant_override("separation", 7)
	modal_panel.add_child(modal_body)
	var title := _label(modal_body, heading, 15)
	title.add_theme_color_override("font_color", AMBER)


func _paragraph(text: String, font_size: int = 10) -> Label:
	var label := _label(modal_body, text, font_size)
	label.autowrap_mode = TextServer.AUTOWRAP_WORD_SMART
	label.custom_minimum_size.x = modal_panel.custom_minimum_size.x - 40
	return label


func _close_panel(restore_focus: bool = true) -> void:
	if is_instance_valid(modal):
		canvas.remove_child(modal)
		modal.queue_free()
		modal = null
	if restore_focus:
		main_menu.show()
		new_game_button.grab_focus.call_deferred()


func _show_difficulty(tutorial_entry: bool = false) -> void:
	tutorial_start = tutorial_entry
	_open_panel("Play Tutorial" if tutorial_entry else "A fresh start")
	_paragraph("Start a fresh guided Day 1. Skip anytime; Esc opens Pause." if tutorial_entry else "Choose your pace. Medium is the default.")
	selected_difficulty = 1
	difficulty_buttons.clear()
	var row := HBoxContainer.new()
	row.add_theme_constant_override("separation", 5)
	modal_body.add_child(row)
	for index in range(GameState.DIFFICULTIES.size()):
		var button := _button(row, str(GameState.DIFFICULTIES[index]["name"]), _select_difficulty.bind(index))
		button.toggle_mode = true
		difficulty_buttons.append(button)
	difficulty_description = _paragraph("")
	difficulty_description.custom_minimum_size.y = 54
	_select_difficulty(1)
	_button(modal_body, "Play Tutorial" if tutorial_entry else "Begin Day 1", _begin_game)
	_button(modal_body, "Back", _close_panel)
	difficulty_buttons[1].grab_focus.call_deferred()


func _select_difficulty(index: int) -> void:
	selected_difficulty = index
	for item in range(difficulty_buttons.size()):
		difficulty_buttons[item].set_pressed_no_signal(item == index)
	var profile: Dictionary = GameState.DIFFICULTIES[index]
	difficulty_description.text = "%s\nResearch: +%d%% base / %d min. Routine repair: %d min." % [profile["description"], profile["research"], profile["research_minutes"], profile["repair_minutes"]]


func _show_help() -> void:
	_open_panel("How to Play", 360)
	var scroll := ScrollContainer.new()
	scroll.custom_minimum_size.y = 168
	scroll.horizontal_scroll_mode = ScrollContainer.SCROLL_MODE_DISABLED
	scroll.focus_mode = Control.FOCUS_ALL
	scroll.follow_focus = true
	modal_body.add_child(scroll)
	var cards := VBoxContainer.new()
	cards.size_flags_horizontal = Control.SIZE_EXPAND_FILL
	cards.add_theme_constant_override("separation", 5)
	scroll.add_child(cards)
	var sections := [
		["judy", "Judy · Move & interact", "WASD / arrows to move. E interacts; E / Enter advances dialogue."],
		["desk", "Research", "Use the desk: four sessions a day. Work costs time and Mood."],
		["tiptop", "TipTop", "Faulty chores make messes. Repair each routine; cleaning alone doesn't fix it."],
		["fridge", "Fullness & Mood", "Eat at the fridge. Coffee-table leisure restores Mood. Low needs reduce research efficiency."],
		["clock", "Time & deadline", "Reach 75% research by Day 3, 8 PM. Sleep at the bed to advance days."],
		["activity", "Activity controls", "Watch 1x, Fast 6x or Skip to finish. Eject cancels without a completion reward."]]
	for section in sections:
		_help_card(cards, section[0], section[1], section[2])
	var footer := HBoxContainer.new()
	footer.add_theme_constant_override("separation", 6)
	modal_body.add_child(footer)
	var tutorial_button := _button(footer, "Play Tutorial", _show_difficulty.bind(true))
	_button(footer, "Back", _close_panel)
	_paragraph("Fresh guided game. Skip anytime; Esc → Main Menu exits.", 8)
	tutorial_button.grab_focus.call_deferred()


func _help_card(parent: Node, kind: String, title: String, text: String) -> void:
	var card := PanelContainer.new()
	card.add_theme_stylebox_override("panel", _style(Color("2d2b30"), Color("65574c"), 4))
	parent.add_child(card)
	var row := HBoxContainer.new()
	row.add_theme_constant_override("separation", 8)
	card.add_child(row)
	var picture := Control.new()
	picture.custom_minimum_size = Vector2(42, 36)
	picture.mouse_filter = Control.MOUSE_FILTER_IGNORE
	row.add_child(picture)
	_help_visual(picture, kind)
	var copy := VBoxContainer.new()
	copy.size_flags_horizontal = Control.SIZE_EXPAND_FILL
	copy.add_theme_constant_override("separation", 2)
	row.add_child(copy)
	var name_label := _label(copy, title, 10)
	name_label.add_theme_color_override("font_color", AMBER)
	var caption := _label(copy, text, 9)
	caption.custom_minimum_size.x = 234
	caption.autowrap_mode = TextServer.AUTOWRAP_WORD_SMART


func _help_visual(parent: Control, kind: String) -> void:
	if kind in ["judy", "tiptop"]:
		var frame := AtlasTexture.new()
		frame.atlas = JUDY if kind == "judy" else TIPTOP
		frame.region = Rect2(0, 0, 48, 48)
		var image := TextureRect.new()
		image.texture = frame
		image.texture_filter = CanvasItem.TEXTURE_FILTER_NEAREST
		image.expand_mode = TextureRect.EXPAND_IGNORE_SIZE
		image.stretch_mode = TextureRect.STRETCH_KEEP_ASPECT_CENTERED
		image.position = Vector2(5, 1)
		image.size = Vector2(32, 34)
		image.mouse_filter = Control.MOUSE_FILTER_IGNORE
		parent.add_child(image)
	elif kind in ["desk", "fridge"]:
		var fixture := Node2D.new()
		fixture.set_script(ART)
		fixture.set("fixture", kind)
		fixture.position = Vector2(21, 32)
		fixture.scale = Vector2.ONE * 0.85
		fixture.process_mode = Node.PROCESS_MODE_DISABLED
		parent.add_child(fixture)
	elif kind == "clock":
		var rim := Line2D.new()
		var points := PackedVector2Array()
		for index in range(17):
			points.append((Vector2(21, 18) + Vector2.from_angle(index * TAU / 16) * 12).round())
		rim.points = points
		rim.width = 1
		rim.default_color = AMBER
		parent.add_child(rim)
		var hands := Line2D.new()
		hands.points = PackedVector2Array([Vector2(21, 9), Vector2(21, 18), Vector2(28, 18)])
		hands.width = 2
		hands.default_color = CREAM
		parent.add_child(hands)
	else:
		for x in [8, 22, 30]:
			var arrow := Polygon2D.new()
			arrow.polygon = PackedVector2Array([Vector2(x, 9), Vector2(x + 7, 15), Vector2(x, 21)])
			arrow.color = AMBER
			parent.add_child(arrow)
		var legend := _label(parent, "1x   6x", 7)
		legend.position = Vector2(6, 24)


func _show_settings() -> void:
	_open_panel("Settings")
	var master := AudioServer.get_bus_index("Master")
	if master >= 0:
		var volume_label := _label(modal_body, "Master volume", 10)
		var slider := HSlider.new()
		slider.min_value = 0
		slider.max_value = 100
		slider.step = 1
		slider.custom_minimum_size.y = 18
		slider.value = 0.0 if AudioServer.is_bus_mute(master) else db_to_linear(AudioServer.get_bus_volume_db(master)) * 100.0
		modal_body.add_child(slider)
		volume_label.text = "Master volume: %d%%" % slider.value
		slider.value_changed.connect(func(value: float):
			AudioServer.set_bus_mute(master, value <= 0)
			AudioServer.set_bus_volume_db(master, linear_to_db(maxf(value / 100.0, 0.0001)))
			volume_label.text = "Master volume: %d%%" % value)
	var fullscreen := CheckButton.new()
	fullscreen.text = "Fullscreen"
	fullscreen.button_pressed = DisplayServer.window_get_mode() in [DisplayServer.WINDOW_MODE_FULLSCREEN, DisplayServer.WINDOW_MODE_EXCLUSIVE_FULLSCREEN]
	fullscreen.disabled = DisplayServer.get_name() == "headless"
	fullscreen.toggled.connect(func(enabled: bool):
		DisplayServer.window_set_mode(DisplayServer.WINDOW_MODE_FULLSCREEN if enabled else DisplayServer.WINDOW_MODE_WINDOWED))
	modal_body.add_child(fullscreen)
	_paragraph("Settings apply immediately for this app session. Display scaling stays unchanged.", 9)
	var back := _button(modal_body, "Back", _close_panel)
	back.grab_focus.call_deferred()


func _begin_game() -> void:
	if starting:
		return
	starting = true
	for button in modal.find_children("*", "BaseButton", true, false):
		button.set("disabled", true)
	get_viewport().gui_release_focus()
	var cover := ColorRect.new()
	cover.color = Color(0, 0, 0, 0)
	canvas.add_child(cover)
	cover.set_anchors_and_offsets_preset(Control.PRESET_FULL_RECT)
	var fade := create_tween().set_pause_mode(Tween.TWEEN_PAUSE_PROCESS)
	fade.tween_property(cover, "color:a", 1.0, 0.25)
	await fade.finished
	GameState.restart()
	GameState.select_difficulty(selected_difficulty)
	if tutorial_start:
		get_tree().set_meta("tutorial_entry", true)
	get_tree().set_meta("restart_playing", true)
	# The fresh HUD releases pause and starts the opening dialogue once ready.
	get_tree().change_scene_to_file("res://scenes/room.tscn")


func _unhandled_input(event: InputEvent) -> void:
	if not starting and event.is_action_pressed("ui_cancel"):
		if is_instance_valid(modal):
			_close_panel()
		get_viewport().set_input_as_handled()
