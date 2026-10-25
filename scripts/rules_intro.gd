extends ColorRect

signal dismissed
const COPY = preload("res://data/rules_text.gd")
var page_index := 0
var pages: Array[Dictionary] = []
var heading: Label
var body: Label
var page_count: Label
var back: Button
var next: Button
var scroll: ScrollContainer
var review := false


func _ready() -> void:
	process_mode = Node.PROCESS_MODE_ALWAYS
	texture_filter = CanvasItem.TEXTURE_FILTER_LINEAR
	color = Color("17191ff7")
	mouse_filter = Control.MOUSE_FILTER_STOP
	var center := CenterContainer.new()
	add_child(center)
	center.set_anchors_and_offsets_preset(Control.PRESET_FULL_RECT)
	var panel := PanelContainer.new()
	panel.custom_minimum_size.x = 338
	var style := StyleBoxFlat.new()
	style.bg_color = Color("23242b")
	style.border_color = Color("e6b369")
	style.set_border_width_all(1)
	style.set_corner_radius_all(5)
	style.set_content_margin_all(12)
	panel.add_theme_stylebox_override("panel", style)
	center.add_child(panel)
	var column := VBoxContainer.new()
	column.add_theme_constant_override("separation", 7)
	panel.add_child(column)
	_label(column, GameText.get_text(COPY.TITLE), 11).add_theme_color_override("font_color", Color("e6b369"))
	heading = _label(column, "", 13)
	scroll = ScrollContainer.new()
	scroll.custom_minimum_size = Vector2(314, 128)
	scroll.horizontal_scroll_mode = ScrollContainer.SCROLL_MODE_DISABLED
	scroll.focus_mode = Control.FOCUS_ALL
	scroll.follow_focus = true
	column.add_child(scroll)
	body = _label(scroll, "", 10)
	body.size_flags_horizontal = Control.SIZE_EXPAND_FILL
	body.autowrap_mode = TextServer.AUTOWRAP_WORD_SMART
	body.add_theme_constant_override("line_spacing", 2)
	_label(column, GameText.get_text(COPY.HINT), 8)
	var footer := HBoxContainer.new()
	footer.add_theme_constant_override("separation", 6)
	column.add_child(footer)
	back = _button(footer, GameText.get_text(COPY.BACK), _back)
	page_count = _label(footer, "", 9)
	page_count.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
	page_count.size_flags_horizontal = Control.SIZE_EXPAND_FILL
	next = _button(footer, GameText.get_text(COPY.NEXT), advance)
	hide()


func _label(parent: Node, text: String, font_size: int) -> Label:
	var label := Label.new()
	label.text = text
	label.add_theme_font_size_override("font_size", font_size)
	parent.add_child(label)
	return label


func _button(parent: Node, text: String, action: Callable) -> Button:
	var button := Button.new()
	button.text = text
	button.custom_minimum_size = Vector2(65, 24)
	button.add_theme_font_size_override("font_size", 9)
	button.pressed.connect(action)
	parent.add_child(button)
	return button


func open(as_review: bool = false) -> void:
	review = as_review
	pages = COPY.pages()
	page_index = 0
	get_tree().paused = true
	show()
	_show_page()


func _show_page() -> void:
	heading.text = pages[page_index]["heading"]
	body.text = pages[page_index]["text"]
	page_count.text = GameText.format_text("rules.page_count", [page_index + 1, pages.size()])
	back.disabled = page_index == 0
	next.text = (GameText.get_text(COPY.CLOSE) if review else GameText.get_text(COPY.START)) if page_index == pages.size() - 1 else GameText.get_text(COPY.NEXT)
	scroll.set_deferred("scroll_vertical", 0)
	next.grab_focus.call_deferred()


func _back() -> void:
	page_index = maxi(0, page_index - 1)
	_show_page()


func advance() -> void:
	if not visible:
		return
	if page_index < pages.size() - 1:
		page_index += 1
		_show_page()
	else:
		hide()
		get_viewport().gui_release_focus()
		dismissed.emit()
