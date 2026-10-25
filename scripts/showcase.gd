extends Control

signal restart_requested
signal main_menu_requested

@export_enum("good", "bittersweet", "bad") var ending := "good"
var research := 0.0
var repaired_count := 0
var elapsed := 0.0
var judy: Sprite2D
var tiptop: Sprite2D
var results: PanelContainer
var restart_button: Button
const CREAM := Color("f5e6cd")
const AMBER := Color("e6b369")
var TITLES := {"good": GameText.get_text("endings.against_all_odds"), "bittersweet": GameText.get_text("endings.good_enough"), "bad": GameText.get_text("endings.it_s_probably_not_fine")}


func _ready() -> void:
	process_mode = Node.PROCESS_MODE_ALWAYS
	size = Vector2(432, 288)
	mouse_filter = Control.MOUSE_FILTER_STOP
	texture_filter = CanvasItem.TEXTURE_FILTER_NEAREST
	var heading := Label.new()
	heading.text = GameText.get_text("endings.university_research_showcase_day_3")
	heading.position = Vector2(0, 10)
	heading.size.x = 432
	heading.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
	heading.add_theme_font_size_override("font_size", 8)
	heading.add_theme_color_override("font_color", CREAM)
	heading.texture_filter = CanvasItem.TEXTURE_FILTER_LINEAR
	add_child(heading)
	judy = Sprite2D.new()
	judy.texture = preload("res://assets/characters/judy_walk_48x48_aligned.png")
	judy.hframes = 4
	judy.vframes = 4
	judy.scale = Vector2.ONE * 0.625
	judy.position = Vector2(190, 164)
	add_child(judy)
	tiptop = Sprite2D.new()
	tiptop.texture = preload("res://assets/characters/tiptop_hover_48x48.png")
	tiptop.hframes = 4
	tiptop.scale = Vector2.ONE * 0.47
	tiptop.position = Vector2(239, 164)
	add_child(tiptop)
	_build_results()


func _build_results() -> void:
	results = PanelContainer.new()
	results.position = Vector2(64, 210)
	results.custom_minimum_size.x = 304
	var style := StyleBoxFlat.new()
	style.bg_color = Color("23242bf5")
	style.border_color = AMBER
	style.set_border_width_all(1)
	style.set_corner_radius_all(4)
	style.set_content_margin_all(6)
	results.add_theme_stylebox_override("panel", style)
	results.texture_filter = CanvasItem.TEXTURE_FILTER_LINEAR
	add_child(results)
	var box := VBoxContainer.new()
	box.add_theme_constant_override("separation", 3)
	results.add_child(box)
	var title := Label.new()
	title.text = TITLES[ending]
	preload("res://scripts/typography.gd").accent(title)
	title.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
	title.add_theme_font_size_override("font_size", 13)
	title.add_theme_color_override("font_color", AMBER)
	box.add_child(title)
	var summary := Label.new()
	summary.text = GameText.format_text("endings.research_1f_routines_repaired_d_4", [research, repaired_count])
	summary.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
	summary.add_theme_font_size_override("font_size", 8)
	summary.add_theme_color_override("font_color", CREAM)
	box.add_child(summary)
	var row := HBoxContainer.new()
	row.add_theme_constant_override("separation", 6)
	box.add_child(row)
	for item in [[GameText.get_text("endings.restart"), restart_requested], [GameText.get_text("endings.main_menu"), main_menu_requested]]:
		var button := Button.new()
		button.text = item[0]
		button.custom_minimum_size.y = 21
		button.size_flags_horizontal = Control.SIZE_EXPAND_FILL
		button.add_theme_font_size_override("font_size", 9)
		button.add_theme_color_override("font_color", CREAM)
		for state in ["normal", "hover", "pressed", "focus"]:
			var surface := StyleBoxFlat.new()
			surface.bg_color = Color("303038") if state == "normal" else Color("594634")
			surface.border_color = Color("8d7154") if state == "normal" else AMBER
			surface.set_border_width_all(1)
			surface.set_corner_radius_all(3)
			button.add_theme_stylebox_override(state, surface)
		var action: Signal = item[1]
		button.pressed.connect(func():
			# Disable both routes before emitting, including repeated Enter presses.
			for child in row.get_children():
				(child as Button).disabled = true
			action.emit())
		row.add_child(button)
		if action == restart_requested:
			restart_button = button
	results.hide()


func finish_dialogue() -> void:
	if results.visible:
		return
	results.show()
	restart_button.grab_focus.call_deferred()


func _process(delta: float) -> void:
	elapsed += delta
	tiptop.frame = int(elapsed * 5) % 4
	tiptop.position.y = 164 + sin(elapsed * 2) * 0.6
	judy.rotation = 0.04 if ending == "bad" else (0.02 if ending == "bittersweet" else 0.0)
	queue_redraw()


func _box(rect: Rect2, color: Color) -> void:
	draw_rect(rect, color)


func _draw() -> void:
	# Cover the full visible viewport, including aspect-ratio margins.
	var screen: Rect2 = get_global_transform_with_canvas().affine_inverse() * get_viewport_rect()
	_box(screen, Color("14151e"))
	var warm := Color("c79b61") if ending == "good" else (Color("9f8969") if ending == "bittersweet" else Color("787990"))
	_box(Rect2(20, 28, 392, 177), Color("3e3032") if ending == "good" else (Color("322e34") if ending == "bittersweet" else Color("282b3d")))
	_box(Rect2(20, 28, 43, 162), Color("633d3c"))
	_box(Rect2(369, 28, 43, 162), Color("633d3c"))
	for x in [25, 38, 51, 373, 386, 399]:
		_box(Rect2(x, 29, 5, 159), Color("4c3037"))
	_box(Rect2(61, 31, 310, 4), Color("ad8150"))
	# Restrained translucent stage light cones; no world light or UI tint.
	for x in [92, 340]:
		draw_colored_polygon(PackedVector2Array([Vector2(x - 5, 36), Vector2(x + 5, 36), Vector2(x + 56, 185), Vector2(x - 56, 185)]), Color(warm, 0.09))
		_box(Rect2(x - 6, 28, 12, 7), Color("29262c"))
		_box(Rect2(x - 3, 34, 6, 2), warm)
	_box(Rect2(85, 41, 262, 88), Color("191c29"))
	_box(Rect2(89, 45, 254, 80), Color("e8debf") if ending == "good" else (Color("c6c4b3") if ending == "bittersweet" else Color("474f67")))
	_box(Rect2(85, 129, 262, 3), Color("b49871"))
	# Projector: coherent results, an unfinished chart, or a failed demo.
	if ending == "bad":
		var shift := int(sin(elapsed * 1.2) * 3)
		for row in range(6):
			_box(Rect2(108 + shift * (row % 2), 54 + row * 10, 205 - row * 17, 3), Color("78849b"))
		_box(Rect2(208, 61, 5, 24), Color("e4ac70"))
		_box(Rect2(208, 91, 5, 5), Color("e4ac70"))
	else:
		_box(Rect2(111, 57, 72, 4), Color("678a83"))
		_box(Rect2(111, 65, 104, 2), Color("999c8b"))
		_box(Rect2(125, 78, 1, 33), Color("707d78"))
		_box(Rect2(125, 110, 177, 1), Color("707d78"))
		for index in range(7):
			var height := 8 + index * 4
			if ending == "bittersweet" and index > 3:
				draw_rect(Rect2(136 + index * 22, 110 - height, 13, height), Color("9f9b89"), false, 1)
			else:
				_box(Rect2(136 + index * 22, 110 - height, 13, height), Color("648b79"))
		if ending == "bittersweet":
			_box(Rect2(283, 57, 8, 2), Color("aa7c58"))
			_box(Rect2(286, 60, 2, 7), Color("aa7c58"))
	# Warm wooden stage with planks, fascia, steps and grounded shadows.
	_box(Rect2(45, 140, 342, 48), Color("926746") if ending == "good" else (Color("78604b") if ending == "bittersweet" else Color("655663")))
	for row in range(5):
		_box(Rect2(45, 145 + row * 9, 342, 1), Color("6b4c3b"))
		for col in range(5):
			_box(Rect2(58 + col * 72 + (24 if row % 2 else 0), 141 + row * 9, 1, 8), Color("70503b"))
	_box(Rect2(44, 188, 344, 12), Color("533b33"))
	_box(Rect2(44, 188, 344, 2), warm)
	_box(Rect2(171, 200, 90, 5), Color("6b4e3c"))
	_box(Rect2(165, 205, 102, 4), Color("493831"))
	var pool := PackedVector2Array()
	for index in range(20):
		pool.append((Vector2(216, 169) + Vector2.from_angle(index * TAU / 20.0) * Vector2(89, 15)).round())
	draw_colored_polygon(pool, Color(warm, 0.12))
	for x in [190, 239]:
		_box(Rect2(x - 11, 177, 22, 3), Color("4c3c37"))
	if ending == "bad":
		for index in range(7):
			var phase := minf(elapsed * 0.5, 1.0)
			var point := Vector2(208 + (index - 3) * 18 * phase, 154 + index % 3 * 10 + sin(elapsed * 0.7 + index) * (1.0 - phase))
			_box(Rect2(point.round(), Vector2(7, 4)), CREAM)
	# Audience silhouettes: enthusiastic, polite, or awkwardly motionless.
	for index in range(11):
		var x := 24 + index * 38
		var y := 222 + index % 2 * 7
		var person := Color("10121c")
		_box(Rect2(x - 6, y - 10, 12, 11), person)
		_box(Rect2(x - 9, y + 1, 18, 21), person)
		if ending == "good" or (ending == "bittersweet" and index % 3 == 0):
			var lift := int(sin(elapsed * (5 if ending == "good" else 2) + index) * 2)
			_box(Rect2(x - 13, y - 4 + lift, 4, 10), Color("272330"))
			_box(Rect2(x + 9, y - 4 - lift, 4, 10), Color("272330"))
		elif ending == "bad" and index % 4 == 0:
			_box(Rect2(x + 9, y - 7, 4, 8), Color("39303b"))
