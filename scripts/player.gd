extends CharacterBody2D

const SPEED := 80.0
const INTERACTION_DISTANCE := 32.0

@onready var desk: Node2D = get_node("../Desk")
@onready var tiptop: Node2D = get_node("../TipTop")
@onready var sink: Node2D = get_node("../Sink")
var tiptop_prompt: Label
var sink_prompt: Label


func _ready() -> void:
	tiptop_prompt = _make_prompt(tiptop, "E - Fix TipTop")
	sink_prompt = _make_prompt(sink, "E - Turn off tap")


func _make_prompt(target: Node2D, text: String) -> Label:
	var label := Label.new()
	label.texture_filter = CanvasItem.TEXTURE_FILTER_LINEAR
	label.text = text
	label.add_theme_font_size_override("font_size", 7)
	label.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
	label.mouse_filter = Control.MOUSE_FILTER_IGNORE
	label.position = Vector2(-48, -24)
	label.size = Vector2(96, 12)
	label.visible = false
	target.add_child(label)
	return label


func _nearest_interaction() -> Node2D:
	if GameState.day_ended or GameState.game_finished:
		return null
	var nearest: Node2D = null
	var nearest_distance := INF
	for target in [desk, tiptop, sink]:
		if target == desk:
			if not desk.get("player_nearby") or GameState.work_sessions_remaining <= 0:
				continue
		elif target == tiptop:
			if GameState.tiptop_fixed or global_position.distance_to(tiptop.global_position) > INTERACTION_DISTANCE:
				continue
		elif not GameState.tap_running or global_position.distance_to(sink.global_position) > INTERACTION_DISTANCE:
			continue
		var distance: float = global_position.distance_squared_to(target.global_position)
		if distance < nearest_distance:
			nearest = target
			nearest_distance = distance
	return nearest


func _unhandled_input(event: InputEvent) -> void:
	if not event.is_action_pressed("interact") or event.is_echo():
		return
	var target := _nearest_interaction()
	if target == null:
		return
	get_viewport().set_input_as_handled()
	if target == desk:
		GameState.work()
	elif target == tiptop:
		GameState.fix_tap()
	else:
		GameState.turn_off_tap()


func _physics_process(_delta: float) -> void:
	var input := Vector2.ZERO
	input.x = Input.get_axis("move_left", "move_right")
	input.y = Input.get_axis("move_up", "move_down")

	if input.length() > 1.0:
		input = input.normalized()

	velocity = input * SPEED
	move_and_slide()
	var target := _nearest_interaction()
	tiptop_prompt.visible = target == tiptop
	sink_prompt.visible = target == sink
	desk.get_node("PromptLabel").visible = bool(desk.get("player_nearby")) and (target == desk or GameState.work_sessions_remaining <= 0)
