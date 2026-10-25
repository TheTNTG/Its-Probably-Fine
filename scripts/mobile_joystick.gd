
extends Control

const BASE_RADIUS := 46.0
const KNOB_RADIUS := 17.0
const DEADZONE := 0.18

var touch_index := -1
var direction := Vector2.ZERO

var _center := Vector2(50, 50)
var _actions := {
	"move_left": 0.0,
	"move_right": 0.0,
	"move_up": 0.0,
	"move_down": 0.0
}


func _ready() -> void:
	custom_minimum_size = Vector2(100, 100)
	size = Vector2(100, 100)
	mouse_filter = Control.MOUSE_FILTER_STOP
	set_process_input(true)
	queue_redraw()


func _draw() -> void:
	draw_circle(_center, BASE_RADIUS, Color(0.12, 0.13, 0.17, 0.50))
	draw_arc(_center, BASE_RADIUS, 0, TAU, 64, Color(0.92, 0.73, 0.48, 0.8), 2.0, true)
	draw_circle(_center + direction * 27.0, KNOB_RADIUS, Color(0.93, 0.79, 0.59, 0.88))


func _input(event: InputEvent) -> void:
	if not visible or get_tree().paused:
		_release()
		return

	if event is InputEventScreenTouch:
		if event.pressed and touch_index == -1:
			if get_global_rect().has_point(event.position):
				touch_index = event.index
				_update_direction(event.position)
				get_viewport().set_input_as_handled()
		elif not event.pressed and event.index == touch_index:
			_release()
			get_viewport().set_input_as_handled()

	elif event is InputEventScreenDrag and event.index == touch_index:
		_update_direction(event.position)
		get_viewport().set_input_as_handled()


func _update_direction(screen_position: Vector2) -> void:
	var local_position := get_global_transform_with_canvas().affine_inverse() * screen_position
	var offset := local_position - _center
	var normalized := offset / BASE_RADIUS

	if normalized.length() < DEADZONE:
		direction = Vector2.ZERO
	else:
		direction = normalized.limit_length(1.0)

	_apply_actions()
	queue_redraw()


func _apply_actions() -> void:
	_set_action("move_left", maxf(-direction.x, 0.0))
	_set_action("move_right", maxf(direction.x, 0.0))
	_set_action("move_up", maxf(-direction.y, 0.0))
	_set_action("move_down", maxf(direction.y, 0.0))


func _set_action(action: String, strength: float) -> void:
	var previous: float = _actions[action]
	if is_equal_approx(previous, strength):
		return

	_actions[action] = strength

	if strength > 0.001:
		Input.action_press(action, strength)
	else:
		Input.action_release(action)


func _release() -> void:
	touch_index = -1
	direction = Vector2.ZERO

	for action in _actions:
		if _actions[action] > 0.0:
			Input.action_release(action)
		_actions[action] = 0.0

	queue_redraw()


func _exit_tree() -> void:
	_release()
