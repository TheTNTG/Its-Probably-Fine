extends Node2D

# Fixture drawing; the shared room outline also builds the wall boundary.
@export_enum("floor", "walls", "desk", "sink", "plant", "bed", "bookshelf", "fridge", "chair", "coffee_table", "counter", "lamp") var fixture := "floor"

const INK := Color("493b35")
const WOOD := Color("805638")
const EDGE := Color("b18457")
const SHADE := Color("503a2d")
const CREAM := Color("eadbc0")
const PAPER := Color("fff0cf")
const GREEN := Color("657a55")
const LEAF := Color("8caa68")
const BLUE := Color("70999e")
const RUST := Color("b77354")
# Reference coordinates divided by 4.8 (1536 x 1024 -> 320 x 214).
# These ground-edge points drive both the stepped drawing and wall collision.
const ROOM_EDGE := [Vector2(42, 42), Vector2(184, 42), Vector2(184, 24), Vector2(231, 24), Vector2(231, 56), Vector2(280, 56), Vector2(280, 173), Vector2(210, 173), Vector2(210, 184), Vector2(173, 184), Vector2(173, 194), Vector2(151, 194), Vector2(151, 184), Vector2(108, 184), Vector2(108, 173), Vector2(42, 173)]
var floor_boards: Array[PackedVector2Array] = []
var chore_active := false
var chore_phase := 0.0
var mosquito_positions: Dictionary = {}


func _ready() -> void:
	texture_filter = CanvasItem.TEXTURE_FILTER_NEAREST
	if fixture == "walls":
		var boundary := StaticBody2D.new()
		var outline := CollisionPolygon2D.new()
		outline.build_mode = CollisionPolygon2D.BUILD_SEGMENTS
		outline.polygon = PackedVector2Array(ROOM_EDGE)
		boundary.add_child(outline)
		add_child(boundary)
		# Give the painted caps and corner pillars physical thickness.
		for point in ROOM_EDGE:
			var pillar := CollisionShape2D.new()
			var footprint := RectangleShape2D.new()
			footprint.size = Vector2(8, 8)
			pillar.shape = footprint
			pillar.position = point
			boundary.add_child(pillar)
	elif fixture == "floor":
		for row in range(29):
			for col in range(-1, 7):
				var tile := Rect2(col * 48 + (24 if row % 2 else 0), 24 + row * 6, 47, 5)
				var corners := PackedVector2Array([tile.position, Vector2(tile.end.x, tile.position.y), tile.end, Vector2(tile.position.x, tile.end.y)])
				floor_boards.append_array(Geometry2D.intersect_polygons(corners, PackedVector2Array(ROOM_EDGE)))
	if fixture in ["plant", "sink", "bookshelf", "bed", "floor"]:
		GameState.state_changed.connect(queue_redraw)


func set_chore_active(active: bool) -> void:
	chore_active = active
	queue_redraw()


func _process(delta: float) -> void:
	if GameState.day_ended or GameState.game_finished:
		return
	if chore_active or (fixture == "sink" and GameState.tap_running) or (fixture == "floor" and GameState.mosquito_level > 0):
		var playback: float = GameState.research_playback_rate if GameState.research_active else (GameState.personal_playback_rate if not GameState.personal_activity.is_empty() else 1.0)
		chore_phase += delta * minf(playback, 3.0)
		queue_redraw()
	if fixture == "floor":
		for id in mosquito_positions.keys():
			if not GameState.mosquitoes.has(id):
				mosquito_positions.erase(id)
		for id in GameState.mosquitoes:
			var current: Vector2 = GameState.mosquitoes[id]["position"]
			var prior: Vector2 = GameState.mosquitoes[id]["previous"]
			# Render between clock samples, rather than stopping at each tick.
			var point := prior.lerp(current, clampf(GameState.world_accumulator / GameState.WORLD_STEP, 0, 1))
			var previous: Vector2 = mosquito_positions.get(id, point)
			mosquito_positions[id] = previous.lerp(point, 1.0 - exp(-14 * delta))


func reset_mosquito_visuals() -> void:
	mosquito_positions.clear()
	queue_redraw()


func _box(x: int, y: int, w: int, h: int, color: Color) -> void:
	draw_rect(Rect2(x, y, w, h), color)


func _oval(center: Vector2, radius: Vector2, color: Color) -> void:
	var points := PackedVector2Array()
	for index in range(24):
		points.append((center + Vector2.from_angle(index * TAU / 24.0) * radius).round())
	draw_colored_polygon(points, color)


func _draw() -> void:
	match fixture:
		"fridge":
			_box(-12, 0, 26, 2, SHADE)
			_box(-12, -34, 24, 34, INK)
			_box(-11, -33, 20, 32, CREAM)
			_box(9, -32, 3, 32, Color("a89b85"))
			_box(-10, -33, 19, 2, PAPER)
			_box(-11, -22, 20, 2, INK)
			_box(-8, -28, 2, 4, SHADE)
			_box(-8, -18, 2, 6, SHADE)
			_box(-1, -17, 6, 7, PAPER)
			_box(0, -15, 4, 1, BLUE)
			_box(1, -18, 2, 2, RUST)
			_box(-4, -9, 5, 4, GREEN)
		"chair":
			_box(-7, 0, 14, 2, SHADE)
			# Face the desk: seat to the north, backrest on the south edge.
			_box(-7, -8, 14, 5, INK)
			_box(-6, -8, 12, 3, Color("81846b"))
			_box(-1, -3, 2, 3, INK)
			_box(-6, -1, 12, 1, INK)
			_box(-6, -3, 12, 4, INK)
			_box(-5, -2, 10, 2, GREEN)
		"floor":
			_box(0, 0, 320, 214, Color("17191f"))
			draw_colored_polygon(PackedVector2Array(ROOM_EDGE), SHADE)
			var boards := [Color("805537"), Color("8d603d"), Color("956743"), Color("855b3a")]
			for index in range(floor_boards.size()):
				var plank := floor_boards[index]
				draw_colored_polygon(plank, boards[index % boards.size()])
				var bounds := Rect2(plank[0], Vector2.ZERO)
				for corner in plank:
					bounds = bounds.expand(corner)
				if bounds.size.x > 22 and bounds.size.y >= 4:
					_box(int(bounds.position.x) + 5, int(bounds.position.y) + 2, 12, 1, Color("785137"))
			# Main rug proportions and round-table placement follow the blueprint.
			_box(118, 106, 78, 56, SHADE)
			_box(119, 105, 75, 55, Color("40563f"))
			_box(121, 107, 71, 51, GREEN)
			_box(125, 111, 63, 43, Color("77825d"))
			for x in range(123, 190, 5):
				_box(x, 108, 2, 2, Color("b6b180"))
				_box(x, 155, 2, 2, Color("b6b180"))
			for y in range(113, 154, 5):
				_box(122, y, 2, 2, Color("b6b180"))
				_box(189, y, 2, 2, Color("b6b180"))
			for y in range(114, 152, 4):
				for x in range(127, 185, 9):
					_box(x + y % 3, y, 3, 1, Color("71805a"))
			_box(201, 96, 25, 7, Color("536144"))
			_box(155, 183, 15, 9, SHADE)
			_box(156, 184, 13, 7, EDGE)
			_box(158, 186, 9, 3, Color("bd9561"))
		"walls":
			var edge := PackedVector2Array(ROOM_EDGE)
			edge.append(edge[0])
			# Thick dark caps, cream faces and a low wood skirting.
			draw_polyline(edge, Color("29282c"), 10.0)
			draw_polyline(edge, Color("6d5542"), 7.0)
			draw_polyline(edge, Color("d3c2a1"), 3.0)
			for index in range(ROOM_EDGE.size()):
				var start: Vector2 = ROOM_EDGE[index]
				var end: Vector2 = ROOM_EDGE[(index + 1) % ROOM_EDGE.size()]
				if start.y == end.y and end.x > start.x:
					draw_line(start + Vector2(0, 4), end + Vector2(0, 4), SHADE, 3.0)
					draw_line(start + Vector2(0, 2), end + Vector2(0, 2), EDGE, 1.0)
			# Structural pillars at the stepped corners, not an enclosing rectangle.
			for corner in [Vector2(42, 42), Vector2(184, 24), Vector2(231, 56), Vector2(280, 56), Vector2(42, 173), Vector2(108, 173), Vector2(210, 173)]:
				_box(int(corner.x) - 4, int(corner.y) - 4, 8, 8, INK)
				_box(int(corner.x) - 2, int(corner.y) - 3, 4, 6, Color("bea88a"))
			# Posters, corkboard and hanging foliage behind the bed and desk.
			_box(65, 37, 22, 14, INK)
			_box(66, 38, 20, 12, BLUE)
			_box(67, 45, 18, 5, GREEN)
			_box(80, 39, 3, 2, PAPER)
			_box(96, 38, 21, 14, SHADE)
			_box(97, 39, 19, 12, EDGE)
			for note in range(4):
				_box(99 + note % 2 * 8, 40 + note / 2 * 5, 6, 4, PAPER)
			_box(46, 48, 6, 4, WOOD)
			for leaf in range(8):
				_box(45 + leaf % 3 * 2, 45 + leaf * 2, 4, 5, GREEN if leaf % 2 else LEAF)
		"desk":
			_box(-17, 0, 34, 2, SHADE)
			_box(-16, -16, 32, 16, INK)
			_box(-15, -15, 30, 11, WOOD)
			_box(-15, -15, 30, 2, EDGE)
			_box(-14, -3, 5, 3, SHADE)
			_box(9, -3, 5, 3, SHADE)
			# Monitor, keyboard and one slightly precarious paper pile.
			_box(-8, -26, 16, 11, INK)
			_box(-7, -25, 14, 8, BLUE)
			_box(-5, -23, 6, 1, PAPER)
			_box(-5, -21, 9, 1, CREAM)
			_box(-1, -15, 2, 3, INK)
			_box(-6, -11, 12, 4, CREAM)
			_box(-5, -10, 10, 1, SHADE)
			_box(-14, -12, 6, 7, PAPER)
			_box(-13, -10, 4, 1, BLUE)
			_box(-13, -8, 3, 1, SHADE)
			# Drawer faces and layered paper edges add depth without moving the seat.
			_box(8, -6, 6, 5, Color("69452f"))
			_box(9, -5, 4, 1, EDGE)
			_box(-14, -5, 5, 1, Color("d5c49e"))
			_box(-12, -13, 4, 1, CREAM)
			_box(12, -22, 1, 6, EDGE)
			_box(9, -25, 7, 4, Color("d5b879"))
			_box(10, -25, 5, 1, PAPER)
		"sink":
			_box(-13, 0, 26, 2, SHADE)
			_box(-12, -16, 24, 16, INK)
			_box(-11, -15, 22, 8, CREAM)
			_box(-10, -7, 20, 6, WOOD)
			_box(-1, -6, 1, 5, SHADE)
			_box(-4, -4, 2, 1, EDGE)
			_box(2, -4, 2, 1, EDGE)
			_box(-8, -14, 13, 6, BLUE)
			_box(-7, -13, 11, 4, Color("49676d"))
			_box(-2, -20, 2, 8, CREAM)
			_box(-2, -20, 6, 2, CREAM)
			_box(7, -17, 3, 6, GREEN)
			_box(7, -19, 2, 2, PAPER)
			# Shallow wall cabinet, tiled backsplash, and hanging towel.
			_box(-13, -39, 26, 12, INK)
			_box(-12, -38, 24, 10, WOOD)
			_box(-11, -37, 10, 7, EDGE)
			_box(1, -37, 10, 7, EDGE)
			_box(-3, -33, 1, 2, INK)
			_box(2, -33, 1, 2, INK)
			_box(-12, -26, 24, 5, Color("d9cdb0"))
			for x in range(-11, 12, 5):
				_box(x, -25, 1, 3, Color("b2aa92"))
			_box(7, -5, 4, 7, PAPER)
			_box(8, -4, 1, 5, Color("c4ba9b"))
		"plant":
			_box(-6, 0, 12, 2, SHADE)
			_box(-5, -9, 10, 9, INK)
			_box(-4, -8, 8, 7, RUST)
			_box(-6, -10, 12, 3, EDGE)
			_box(-1, -22, 2, 13, GREEN)
			var wilt: int = GameState.chore_mess["plant"] if get_parent().name == "PlantPot" else 0
			if wilt < 2:
				_box(-7, -20, 7, 5, GREEN)
				_box(0, -25, 6, 6, LEAF)
				_box(1, -17, 7, 5, GREEN)
				_box(-6, -22, 4, 3, LEAF)
			else:
				# Downturned tips, not an unrecognizable pile of foliage.
				draw_colored_polygon(PackedVector2Array([Vector2(0, -22), Vector2(-8, -18), Vector2(-9, -12 - wilt), Vector2(-5, -16)]), GREEN)
				draw_colored_polygon(PackedVector2Array([Vector2(0, -21), Vector2(7, -20), Vector2(9, -12), Vector2(4, -16)]), LEAF)
				_box(-2, -23, 4, 5, GREEN)
		"bed":
			_box(-17, 0, 34, 2, SHADE)
			_box(-16, -47, 32, 47, INK)
			_box(-15, -46, 30, 8, WOOD)
			_box(-14, -45, 28, 2, EDGE)
			_box(-13, -39, 26, 35, CREAM)
			_box(-10, -37, 20, 8, PAPER)
			_box(-13, -27, 26, 23, GREEN)
			_box(-12, -26, 24, 2, LEAF)
			_box(8, -23, 2, 17, Color("54664a"))
			_box(-15, -4, 30, 4, WOOD)
			_box(-15, -4, 30, 1, EDGE)
			_box(-14, -38, 1, 32, Color("c4b596"))
			_box(-9, -36, 18, 1, Color("fff5dc"))
			for y in range(-22, -5, 5):
				_box(-10, y, 13, 1, Color("70855b"))
			_box(-16, -2, 3, 4, INK)
			_box(13, -2, 3, 4, INK)
		"bookshelf":
			_box(-18, 0, 36, 2, SHADE)
			_box(-17, -29, 34, 29, INK)
			_box(-16, -28, 32, 27, WOOD)
			for y in [-25, -13]:
				_box(-13, y, 26, 9, SHADE)
				for book in range(6):
					var colors := [GREEN, RUST, BLUE, CREAM]
					var height := 6 + book % 3
					_box(-12 + book * 4, y + 9 - height, 3, height, colors[book % 4])
					_box(-12 + book * 4, y + 7, 3, 1, EDGE)
				_box(-15, y + 9, 30, 2, EDGE)
			_box(-17, -31, 34, 3, EDGE)
			_box(-13, -34, 10, 3, RUST)
			_box(-12, -33, 8, 1, PAPER)
			_box(5, -34, 5, 3, CREAM)
			_box(7, -39, 1, 5, GREEN)
			_box(4, -38, 4, 2, LEAF)
			_box(8, -40, 3, 3, GREEN)
		"coffee_table":
			# Pixel-stepped round top, thick front lip, and short grounded legs.
			_oval(Vector2(1, 1), Vector2(15, 4), Color("473c3266"))
			_box(-10, -4, 3, 6, INK)
			_box(8, -4, 3, 6, INK)
			_oval(Vector2(0, -6), Vector2(14, 8), INK)
			_oval(Vector2(0, -9), Vector2(14, 8), EDGE)
			_oval(Vector2(0, -9), Vector2(13, 7), WOOD)
			_box(-8, -14, 15, 1, EDGE)
			_box(-7, -6, 6, 3, RUST)
			_box(-6, -6, 4, 1, PAPER)
			_box(-9, -11, 4, 4, CREAM)
			_box(-8, -11, 2, 1, SHADE)
			_box(-5, -10, 1, 2, CREAM)
			_box(4, -10, 5, 4, RUST)
			_box(6, -16, 1, 6, GREEN)
			_box(2, -15, 5, 3, LEAF)
			_box(7, -18, 4, 4, GREEN)
		"counter":
			_box(-17, 0, 35, 2, SHADE)
			_box(-16, -18, 32, 18, INK)
			_box(-15, -10, 30, 9, WOOD)
			_box(-14, -8, 12, 6, Color("90603b"))
			_box(1, -8, 13, 6, Color("90603b"))
			_box(-12, -7, 8, 1, EDGE)
			_box(4, -7, 7, 1, EDGE)
			_box(-16, -19, 31, 9, Color("ad8053"))
			_box(-15, -19, 29, 1, Color("d0aa71"))
			_box(14, -18, 2, 16, SHADE)
			# Coffee maker, chopping board, jar, and a folded tea towel.
			_box(-12, -28, 7, 12, INK)
			_box(-11, -27, 5, 3, BLUE)
			_box(-10, -23, 3, 5, CREAM)
			_box(-11, -17, 5, 1, EDGE)
			_box(-1, -18, 10, 5, Color("d2af77"))
			_box(2, -17, 4, 2, RUST)
			_box(10, -23, 3, 7, Color("b78c59"))
			_box(10, -24, 3, 2, CREAM)
			_box(-3, -13, 5, 7, PAPER)
			_box(-2, -12, 1, 5, BLUE)
		"lamp":
			_box(-5, 0, 10, 2, SHADE)
			_box(-4, -2, 8, 2, WOOD)
			_box(-1, -16, 2, 14, EDGE)
			draw_colored_polygon(PackedVector2Array([Vector2(-3, -22), Vector2(3, -22), Vector2(6, -15), Vector2(-6, -15)]), Color("d9b876"))
			_box(-3, -21, 5, 6, PAPER)
			_box(-6, -15, 12, 1, EDGE)
	_draw_chore_details()
	if fixture == "floor" and GameState.mosquito_level > 0:
		for fly in GameState.mosquitoes:
			var point: Vector2 = mosquito_positions.get(fly, GameState.mosquitoes[fly]["position"])
			_box(int(point.x), int(point.y), 1, 2, INK)
			_box(int(point.x) - 1, int(point.y) + int(chore_phase * 12) % 2, 3, 1, Color("b9af99"))


func _draw_chore_details() -> void:
	if not GameState.chore_mess.has(fixture):
		return
	if fixture == "plant" and get_parent().name != "PlantPot":
		return
	var mess: int = GameState.chore_mess[fixture]
	var beat := int(chore_phase * 6) % 3
	match fixture:
		"bed":
			if mess > 0:
				_box(-10, -36, 16, 6, PAPER)
				_box(3, -31, 7, 5, CREAM)
				draw_colored_polygon(PackedVector2Array([Vector2(-13, -24), Vector2(13, -19), Vector2(8, -13), Vector2(-13, -17)]), LEAF)
				_box(-9, -9, 15, 2, Color("54664a"))
			if chore_active:
				_box(-9 + beat * 4, -22, 8, 2, CREAM)
		"plant":
			if mess > 0:
				_box(-4, -10, 8, 2, Color("392f2b"))
				_box(-6 - mess * 2, 1, 12 + mess * 4, 2 + mess, Color("526d68"))
				_box(-3 - mess, 2, 7 + mess * 2, 1, BLUE)
				if mess == 3:
					_box(-8, -15, 2, 3, Color("ac9451"))
					_box(8, -12, 2, 2, Color("ac9451"))
			if chore_active and GameState.repairs["plant"] and mess > 0:
				_box(-8 + beat * 4, 1, 7, 2, PAPER)
			elif chore_active:
				_box(-14, -22, 6, 5, BLUE)
				_box(-8, -20, 4, 2, BLUE)
				for drop in range(3):
					var fall := int(fposmod(chore_phase * 15 + drop * 4, 10))
					_box(-5 + drop * 2, -19 + fall, 1, 2, PAPER if drop == 1 else BLUE)
				_box(-4 + beat * 3, -10, 2, 1, PAPER)
		"sink":
			# A repaired wash is a local visual action, never the faulty tap flag.
			var washing_dishes: bool = chore_active and GameState.repairs["sink"] and GameState.sink_dirty_dishes
			if GameState.tap_running or washing_dishes:
				_box(1, -18, 2, 8, BLUE)
				_box(1, -18 + beat * 2, 1, 2, PAPER)
				_box(-3 + beat, -10, 3, 1, PAPER)
				_box(4, -12 - beat, 1, 2, BLUE)
				_box(-4, -13 + beat, 1, 1, PAPER)
				if GameState.tap_running and GameState.sink_water_elapsed >= 8.0:
					_box(-8, -9, 13, 2, BLUE)
					_box(-7, -7, 2, 7 + beat, BLUE)
					_box(-7, -5 + beat, 1, 2, PAPER)
			# Floor water stays after shutoff and expands only in bounded stages.
			var water_stage := mini(3, int(GameState.sink_water_elapsed / 8.0))
			if water_stage > 0:
				var width := 12 + water_stage * 6
				_box(-width / 2, 1, width, 2 + water_stage, Color("526d68"))
				_box(-width / 2 + 3, 3, width - 6, 2 + water_stage, BLUE)
				_box(-3, 4, 6 + water_stage, 1, Color("9bb8af"))
				if water_stage >= 2:
					_box(8, 5, 5, 2, Color("526d68"))
			if mess > 0:
				for plate in range(mess + 1):
					_box(4, -11 - plate * 2, 7, 1, PAPER)
				_box(6, -9 - mess * 2, 3, 1, SHADE)
			if GameState.sink_dirty_dishes:
				# Two used plates, a food mark and a fork; no extra floor water.
				_box(-10, -9, 7, 2, SHADE)
				_box(-10, -10, 7, 1, PAPER)
				_box(-9, -12, 6, 1, CREAM)
				_box(-7, -12, 2, 1, RUST)
				_box(3, -13, 1, 5, INK)
				_box(2, -14, 3, 1, INK)
			if washing_dishes:
				_box(-8 + beat * 3, -12, 4, 2, PAPER)
				_box(-6 + beat * 2, -10, 2, 1, BLUE)
			elif chore_active and GameState.repairs["sink"] and not GameState.tap_running and (mess > 0 or GameState.sink_water_elapsed >= 8.0):
				_box(-9 + beat * 4, -8, 1, 13, EDGE)
				_box(-13 + beat * 4, 4, 9, 2, PAPER)
			elif chore_active:
				for bubble in range(3):
					_box(-6 + bubble * 4, -13 - (beat + bubble) % 3, 2, 2, PAPER)
		"bookshelf":
			if GameState.bookshelf_minor_clutter:
				# A consulted reference left horizontally on the lower shelf.
				# Malfunction scattering below remains a separate, larger state.
				_box(-10, -6, 11, 3, BLUE)
				_box(-9, -5, 9, 1, PAPER)
				_box(-8, -9, 9, 2, RUST)
				_box(4, -12, 5, 2, PAPER)
			if mess > 0:
				_box(-13, -25, 26, 9, SHADE)
				for book in range(5):
					var lean := 0.15 * mess * (-1 if book % 2 else 1)
					draw_set_transform(Vector2(-10 + book * 5, -17), lean)
					_box(-1, -6 - book % 2, 3, 7, BLUE if book % 2 else RUST)
					_box(-1, -2, 3, 1, EDGE)
					draw_set_transform(Vector2.ZERO)
				for book in range(mess):
					draw_set_transform(Vector2(-11 + book * 9, 3 + book % 2 * 3), -0.2 if book % 2 else 0.2)
					_box(-4, -2, 8, 5, BLUE if book % 2 else RUST)
					_box(-3, -1, 6, 2, PAPER)
					draw_set_transform(Vector2.ZERO)
			if chore_active:
				var shift := int(round(sin(chore_phase * 5.0) * 5.0))
				_box(shift - 2, -21, 4, 7, CREAM)
				_box(shift - 1, -20, 2, 1, RUST)
