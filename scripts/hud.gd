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
var end_day_button: Button
var sessions_label: Label


func _ready() -> void:
	process_mode = Node.PROCESS_MODE_ALWAYS
	_build_loop_ui()
	_smooth_ui_text(self)
	GameState.state_changed.connect(_update_hud)
	GameState.malfunction_triggered.connect(_show_malfunction)
	_update_hud()


func _smooth_ui_text(node: Node) -> void:
	if node is Control:
		node.texture_filter = CanvasItem.TEXTURE_FILTER_LINEAR
	for child in node.get_children():
		_smooth_ui_text(child)


func _update_hud() -> void:
	if not GameState.notification_active and fix_button.visible:
		notification_panel.hide()
	day_label.text = "Day %d" % GameState.day
	time_label.text = GameState.get_time_string()
	research_label.text = "Research: %d%%" % GameState.research_progress
	sessions_label.text = "Work sessions remaining: %d" % GameState.work_sessions_remaining
	end_day_button.visible = not GameState.day_ended and not GameState.game_finished
	if GameState.day_ended or GameState.game_finished:
		notification_panel.hide()
		get_tree().paused = true
		loop_panel.show()
		if GameState.game_finished:
			loop_button.text = "Restart"
			if GameState.research_progress >= 80 and GameState.tiptop_fixed:
				loop_message.text = "Showcase: It's probably fine!\nYour research impresses the visitors,\nand TipTop runs without a leak."
			elif GameState.research_progress >= 80:
				loop_message.text = "Showcase: Bittersweet.\nYour research impresses the visitors,\nbut TipTop's unresolved tap problem steals the show."
			else:
				loop_message.text = "Showcase: A work in progress.\nYour unfinished research needs more time."
		else:
			loop_message.text = "Day %d complete — 18:00\nResearch: %d%%\nShowcase deadline: Day 3, 18:00" % [GameState.day, GameState.research_progress]
			loop_button.text = "Showcase" if GameState.day == 3 else "Next day"


func _show_malfunction(message: String) -> void:
	notification_label.text = message
	fix_button.visible = true
	ignore_button.visible = true
	notification_panel.visible = true


func _on_fix_pressed() -> void:
	notification_label.text = "Tap fixed. TipTop updated."
	fix_button.visible = false
	ignore_button.visible = false
	GameState.fix_tap()
	await get_tree().create_timer(1.5).timeout
	if not GameState.notification_active:
		notification_panel.visible = false


func _on_ignore_pressed() -> void:
	notification_panel.visible = false
	GameState.ignore_tap()


func _build_loop_ui() -> void:
	sessions_label = Label.new()
	sessions_label.position = Vector2(4, 28)
	sessions_label.add_theme_font_size_override("font_size", 7)
	add_child(sessions_label)
	end_day_button = Button.new()
	end_day_button.process_mode = Node.PROCESS_MODE_PAUSABLE
	end_day_button.position = Vector2(252, 18)
	end_day_button.size = Vector2(64, 18)
	end_day_button.add_theme_font_size_override("font_size", 7)
	end_day_button.text = "End day"
	end_day_button.pressed.connect(GameState.end_day)
	add_child(end_day_button)
	var deadline := Label.new()
	deadline.position = Vector2(4, 16)
	deadline.add_theme_font_size_override("font_size", 7)
	deadline.text = "Showcase deadline: Day 3, 18:00"
	add_child(deadline)
	loop_panel = ColorRect.new()
	loop_panel.position = Vector2(10, 42)
	loop_panel.size = Vector2(300, 112)
	loop_panel.color = Color(0.08, 0.08, 0.12, 0.98)
	add_child(loop_panel)
	loop_message = Label.new()
	loop_message.position = Vector2(8, 8)
	loop_message.size = Vector2(284, 66)
	loop_message.add_theme_font_size_override("font_size", 8)
	loop_message.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
	loop_message.autowrap_mode = TextServer.AUTOWRAP_WORD_SMART
	loop_message.text = "Prepare for the Day 3 showcase!\nReach 80% research and fix TipTop's routine.\nE to interact. 4 work sessions/day.\nWork: +10%/30 min; tap on: +5%/40 min.\nFix TipTop: 30 min."
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
	if GameState.game_finished:
		GameState.restart()
		get_tree().paused = false
		get_tree().reload_current_scene()
		return
	loop_panel.hide()
	get_tree().paused = false
	if GameState.day_ended:
		GameState.continue_day()
