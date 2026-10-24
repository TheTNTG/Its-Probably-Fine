extends Node2D

# Decorative drawing only; physics and interactions remain in the scenes.
@export_enum("floor", "walls", "desk", "sink", "plant", "bed", "bookshelf", "fridge", "chair") var fixture := "floor"

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
var chore_active := false
var chore_phase := 0.0


func _ready() -> void:
	if fixture in ["plant", "sink", "bookshelf", "bed", "floor"]:
		GameState.state_changed.connect(queue_redraw)


func set_chore_active(active: bool) -> void:
	chore_active = active
	queue_redraw()


func _process(delta: float) -> void:
	if GameState.day_ended or GameState.game_finished:
		return
	if fixture == "sink" and GameState.tap_running and not GameState.research_active:
		# One elapsed counter, owned by the existing state and frozen on shutoff.
		GameState.sink_water_elapsed = minf(31.0, GameState.sink_water_elapsed + delta)
	if chore_active or (fixture == "sink" and GameState.tap_running) or (fixture == "floor" and GameState.mosquito_level > 0):
		var playback := GameState.research_playback_rate if GameState.research_active else 1.0
		chore_phase += delta * minf(playback, 3.0)
		queue_redraw()


func _box(x: int, y: int, w: int, h: int, color: Color) -> void:
	draw_rect(Rect2(x, y, w, h), color)


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
			_box(0, 0, 320, 180, Color("1d1c23"))
			_box(52, 40, 216, 132, WOOD)
			var boards := [Color("795236"), Color("80583b"), Color("875e40")]
			for row in range(11):
				for col in range(-1, 7):
					var x := col * 56 + (28 if row % 2 else 0)
					var left := maxi(52, x)
					var right := mini(268, x + 55)
					if right > left:
						_box(left, 40 + row * 12, right - left, 11, boards[posmod(row + col, 3)])
						if right - left > 20:
							_box(left + 4, 43 + row * 12, 12, 1, WOOD)
			# Woven rug: low contrast, safely underneath all sortable objects.
			_box(128, 94, 64, 38, SHADE)
			_box(130, 96, 60, 34, GREEN)
			_box(133, 99, 54, 28, Color("91977a"))
			for x in range(134, 188, 6):
				_box(x, 96, 2, 2, CREAM)
				_box(x, 128, 2, 2, CREAM)
		"walls":
			_box(44, 32, 232, 8, INK)
			_box(46, 33, 228, 4, CREAM)
			_box(48, 37, 224, 2, EDGE)
			_box(52, 39, 216, 2, SHADE)
			_box(44, 40, 8, 140, SHADE)
			_box(46, 40, 4, 132, CREAM)
			_box(268, 40, 8, 140, SHADE)
			_box(270, 40, 4, 132, CREAM)
			_box(44, 172, 232, 8, SHADE)
			_box(48, 172, 224, 2, EDGE)
			# Contact shade along the inside corners and rear skirting.
			_box(52, 41, 216, 2, Color("46372d"))
			_box(52, 43, 2, 129, Color("60422f"))
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
	_draw_chore_details()
	if fixture == "floor" and GameState.mosquito_level > 0:
		for fly in range(GameState.mosquito_level * 2):
			var anchor: Vector2 = get_node("../Sink").position if fly % 2 else get_node("../PlantPot").position
			var point := anchor + Vector2(sin(chore_phase * 2 + fly * 3) * 12, 3 + cos(chore_phase * 3 + fly) * 5)
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
			if GameState.tap_running:
				_box(1, -18, 2, 8, BLUE)
				_box(1, -18 + beat * 2, 1, 2, PAPER)
				_box(-3 + beat, -10, 3, 1, PAPER)
				_box(4, -12 - beat, 1, 2, BLUE)
				_box(-4, -13 + beat, 1, 1, PAPER)
				if GameState.sink_water_elapsed >= 8.0:
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
			if chore_active and GameState.repairs["sink"] and not GameState.tap_running and (mess > 0 or GameState.sink_water_elapsed >= 8.0):
				_box(-9 + beat * 4, -8, 1, 13, EDGE)
				_box(-13 + beat * 4, 4, 9, 2, PAPER)
			elif chore_active:
				for bubble in range(3):
					_box(-6 + bubble * 4, -13 - (beat + bubble) % 3, 2, 2, PAPER)
		"bookshelf":
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
