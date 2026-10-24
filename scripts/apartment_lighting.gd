extends Node2D

# Presentation only. All animation is sampled from the authoritative world clock.
const ART = preload("res://scripts/apartment_visual.gd")
const EVENING_START := GameState.DAY_END - 180.0
const HOURS := [540.0, 720.0, 900.0, 1020.0, 1080.0]
# Broad neutral daylight gives way to a cool, readable evening baseline.
# Warmth after dusk comes from local lights, not an orange ambient filter.
const AMBIENT := [Color(0.93, 0.96, 1.0), Color(1.0, 1.0, 1.0), Color(0.94, 0.93, 0.88), Color(0.57, 0.63, 0.75), Color(0.38, 0.44, 0.58)]
const SUN := [Color("ffedc4"), Color("fffdf2"), Color("ffda98"), Color("ffc17b"), Color("d1b798")]
const LENGTH := [110.0, 62.0, 130.0, 150.0, 160.0]
const STRENGTH := [0.28, 0.16, 0.33, 0.09, 0.012]
var ambient: CanvasModulate
var lamps: Array[PointLight2D] = []
var sampled_time := -1.0
var sun_color := Color.WHITE
var sun_length := 100.0
var sun_strength := 0.06


func _ready() -> void:
	# Draw floor illumination beneath walls and all sortable furniture/characters.
	z_index = -2
	ambient = CanvasModulate.new()
	add_child(ambient)
	var room := get_parent()
	_add_lamp(to_local(room.get_node("BedsideLamp").to_global(Vector2(0, -18))))
	_add_lamp(to_local(room.get_node("Desk").to_global(Vector2(12, -23))))
	GameState.state_changed.connect(_update_from_clock)
	_update_from_clock()


func _add_lamp(point: Vector2) -> void:
	# A small radial mask, generated once, clipped to the actual room silhouette.
	# The clipped texture prevents glow spilling into the black exterior.
	var mask := Image.create(128, 128, false, Image.FORMAT_RGBA8)
	var room_polygon := PackedVector2Array(ART.ROOM_EDGE)
	for y in range(128):
		for x in range(128):
			var offset := Vector2(x + 0.5, y + 0.5) - Vector2(64, 64)
			var falloff := pow(maxf(0.0, 1.0 - offset.length() / 62.0), 1.8)
			if falloff > 0.0 and not _visible_from_lamp(point, point + offset, room_polygon):
				falloff = 0.0
			# Encode falloff in RGB: the light shader receives zero energy at
			# the edge/exterior regardless of how it handles texture alpha.
			mask.set_pixel(x, y, Color(falloff, falloff, falloff, 1))
	var lamp := PointLight2D.new()
	lamp.position = point
	lamp.texture = ImageTexture.create_from_image(mask)
	lamp.texture_filter = CanvasItem.TEXTURE_FILTER_LINEAR
	lamp.color = Color("ffd49a")
	lamp.blend_mode = Light2D.BLEND_MODE_ADD
	lamp.shadow_enabled = false
	lamp.energy = 0.0
	add_child(lamp)
	lamps.append(lamp)


func _visible_from_lamp(origin: Vector2, point: Vector2, polygon: PackedVector2Array) -> bool:
	if not Geometry2D.is_point_in_polygon(point, polygon):
		return false
	for edge in range(polygon.size()):
		if Geometry2D.segment_intersects_segment(origin, point, polygon[edge], polygon[(edge + 1) % polygon.size()]) != null:
			return false
	return true


func _process(_delta: float) -> void:
	# Pending fractions provide smooth Watch/6x changes without a second timer.
	_update_from_clock()


func _update_from_clock() -> void:
	var minutes := clampf(GameState.time_minutes + GameState.clock_fraction + GameState.world_accumulator, HOURS[0], HOURS[-1])
	if is_equal_approx(minutes, sampled_time):
		return
	sampled_time = minutes
	var phase := 0
	while phase < HOURS.size() - 2 and minutes >= HOURS[phase + 1]:
		phase += 1
	var blend := smoothstep(HOURS[phase], HOURS[phase + 1], minutes)
	ambient.color = AMBIENT[phase].lerp(AMBIENT[phase + 1], blend)
	sun_color = SUN[phase].lerp(SUN[phase + 1], blend)
	sun_length = lerpf(LENGTH[phase], LENGTH[phase + 1], blend)
	sun_strength = lerpf(STRENGTH[phase], STRENGTH[phase + 1], blend)
	# Bring lamps in with the daylight fade, starting three hours before cutoff.
	var evening := smoothstep(EVENING_START, float(GameState.DAY_END), minutes)
	for lamp in lamps:
		lamp.energy = 1.35 * evening
	queue_redraw()


func _draw() -> void:
	if sampled_time < 0:
		return
	var room_polygon := PackedVector2Array(ART.ROOM_EDGE)
	var day_fraction := (sampled_time - HOURS[0]) / (HOURS[-1] - HOURS[0])
	var direction := Vector2(0.88 - day_fraction * 0.13, 0.53 + day_fraction * 0.17).normalized()
	var across := Vector2(-direction.y, direction.x)
	for beam in range(3):
		var entry := Vector2(45, 58 + beam * 20)
		var tip := entry + direction * sun_length
		# Soft window-mullion shade between shafts; all shading stays on
		# the floor layer, so it cannot darken faces, furniture or the UI.
		var shadow_entry := entry + across * 12.0
		var shadow_tip := shadow_entry + direction * sun_length * 0.94
		for feather in range(4):
			var width := 1.0 + feather * 0.8
			var shadow := PackedVector2Array([shadow_entry - across * width, shadow_tip - across * width, shadow_tip + across * width, shadow_entry + across * width])
			for clipped in Geometry2D.intersect_polygons(shadow, room_polygon):
				draw_colored_polygon(clipped, Color(0.16, 0.20, 0.28, sun_strength * 0.14))
		# Nested translucent tapered shapes soften both edges and the far end.
		for feather in range(6):
			var width := 5.0 + (5 - feather) * 1.4
			var end := tip - direction * feather * 3.0
			var shape := PackedVector2Array([entry - across * width, end - across * width * 0.65, end + across * width * 0.65, entry + across * width])
			var tint := sun_color
			tint.a = sun_strength / 6.0
			for clipped in Geometry2D.intersect_polygons(shape, room_polygon):
				draw_colored_polygon(clipped, tint)
		# Four sparse motes per shaft; slow motion freezes with world time.
		for mote in range(4):
			var drift := fposmod((sampled_time - HOURS[0]) * 0.18 + mote * 0.23 + beam * 0.11, 1.0)
			var point := entry + direction * (12.0 + drift * (sun_length - 24.0))
			point += across * sin(drift * TAU + mote * 2.0) * 4.0
			if Geometry2D.is_point_in_polygon(point, room_polygon):
				var tint := sun_color
				tint.a = sin(drift * PI) * 0.20 * minf(1.0, sun_strength / 0.20)
				draw_rect(Rect2(point.floor(), Vector2.ONE), tint)
