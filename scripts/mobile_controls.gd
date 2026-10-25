
extends CanvasLayer

@onready var interact_button: TouchScreenButton = $InteractButton
@onready var pause_button: TouchScreenButton = $PauseButton

const INTERACT_RADIUS := 32
const PAUSE_RADIUS := 20


func _ready() -> void:
	if interact_button == null:
		push_error("MobileControls: InteractButton not found!")
		return

	if pause_button == null:
		push_error("MobileControls: PauseButton not found!")
		return

	_setup_button(interact_button, "E", INTERACT_RADIUS, "interact")
	interact_button.action = ""
	interact_button.pressed.connect(_simulate_e_press)
	interact_button.released.connect(_simulate_e_release)
	_setup_button(pause_button, "II", PAUSE_RADIUS, "pause")

	get_viewport().size_changed.connect(_position_buttons)
	_position_buttons()
	
	


func _setup_button(
	button: TouchScreenButton,
	label: String,
	radius: int,
	action: String
) -> void:
	var image_size := radius * 2 + 4
	var image := Image.create(
		image_size,
		image_size,
		false,
		Image.FORMAT_RGBA8
	)

	image.fill(Color.TRANSPARENT)

	var center := Vector2(image_size / 2.0, image_size / 2.0)

	for y in range(image_size):
		for x in range(image_size):
			var distance := Vector2(x, y).distance_to(center)

			if distance <= radius:
				image.set_pixel(x, y, Color("#ba8752"))
			if distance > radius - 2 and distance <= radius:
				image.set_pixel(x, y, Color("#efc58e"))

	var texture := ImageTexture.create_from_image(image)

	button.texture_normal = texture
	button.action = action
	button.visibility_mode = TouchScreenButton.VISIBILITY_ALWAYS
	button.passby_press = false

	var shape := CircleShape2D.new()
	shape.radius = radius
	button.shape = shape
	button.shape_centered = true

	# Text is drawn into the button texture.
	# We'll improve the button lettering in the next visual pass.


func _position_buttons() -> void:
	interact_button.position = Vector2(400, 300)
	pause_button.position = Vector2(500, 300)

	interact_button.visible = true
	pause_button.visible = true

	interact_button.modulate = Color.WHITE
	pause_button.modulate = Color.WHITE

	print("E button position: ", interact_button.position)
	print("Pause button position: ", pause_button.position)
	print("E texture: ", interact_button.texture_normal)
	print("Pause texture: ", pause_button.texture_normal)
	
func _simulate_e_press() -> void:
	print("MOBILE E PRESSED")

	var event := InputEventKey.new()
	event.keycode = KEY_E
	event.physical_keycode = KEY_E
	event.pressed = true
	event.echo = false

	Input.parse_input_event(event)

func _simulate_e_release() -> void:
	var event := InputEventKey.new()
	event.keycode = KEY_E
	event.physical_keycode = KEY_E
	event.pressed = false

	Input.parse_input_event(event)
