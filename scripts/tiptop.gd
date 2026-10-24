extends CharacterBody2D

const SPEED := 28.0
const CELL := 8.0
const APARTMENT_ART = preload("res://scripts/apartment_visual.gd")
var grid := AStarGrid2D.new()
var path := PackedVector2Array()
var visit := 0
var wait := 0.0
var stalled := 0.0
var mapped := false
var last_day := 1
var destination := Vector2.ZERO
var bookshelf_approach := Vector2.ZERO
var has_destination := false
var action_left := 0.0
var near_judy := false
var repath_cooldown := 0.0
var action_label: Label
var monologue_label: Label
var monologue_left := 0.0
const CHORES := ["plant", "sink", "bookshelf", "bed"]
enum BrainState { IDLE, SELECT_TASK, MOVING_TO_TASK, PERFORMING_TASK, REACTING, COOLDOWN, RECOVERING }
var brain_state := BrainState.IDLE
var reaction_left := 0.0
var blocked_elapsed := 0.0
var morning_day := 0
var goodnight_day := 0
var thought_counts: Dictionary = {}
const APPROACH_THOUGHTS := {
	"sink": ["Time to give those dishes a fresh start.", "Dish duty. My specialty. One of four."],
	"plant": ["Checking on our leafy colleague.", "The plant has requested my attention. Silently."],
	"bookshelf": ["The bookshelf requires my expertise.", "Books. Such rectangular possibilities."],
	"bed": ["A tidy bed supports untidy scientific ideas.", "Checking the sheet situation."]
}
const FAULTY_WORK_THOUGHTS := {
	"sink": ["Maximum cleanliness requires maximum water!", "A continuous rinse. Very thorough."],
	"plant": ["Plants love water. More must be better!", "A generous drink for a generous plant."],
	"bookshelf": ["Largest books on top. A superior system.", "Testing a more aerodynamic arrangement."],
	"bed": ["Extra ventilation for every sheet!", "A little creative folding should help."]
}
const REPAIRED_WORK_THOUGHTS := {
	"sink": ["Tap off. Dishes clean. Floor stays dry.", "A controlled rinse. I have revised my methods."],
	"plant": ["Just enough water. Excellent restraint.", "Checking the soil before I pour."],
	"bookshelf": ["Titles in order. Spines facing out.", "Upright books. A surprisingly elegant solution."],
	"bed": ["Corners tucked. Pillow restored.", "Smoothing, not aerating. I remember."]
}
const FAULTY_REACTIONS := {
	"sink": ["Dish cycle successful.", "The water is certainly flowing efficiently."],
	"plant": ["Hydration complete.", "Our colleague will be delighted."],
	"bookshelf": ["A bold new arrangement. Excellent.", "Book order optimized."],
	"bed": ["Sheets aerated.", "A refreshingly unconventional bed."]
}
const REPAIRED_REACTIONS := {
	"sink": ["Clean dishes. No bonus indoor pond.", "Another successful chore!"],
	"plant": ["Water delivered. Correct amount this time.", "A healthy plant and a dry floor. Remarkable."],
	"bookshelf": ["Alphabetical. And upright. All done.", "Everything in its place. Even the books."],
	"bed": ["Bed made. I shall leave it made.", "Ready for sleeping. Or admiring briefly."]
}
var cleanup_target := false
var swatting := false
var session_serial := -1
var finished_chore_serial := -1
var task_outcome := "idle"
var navigation_attempts := 0
var travel_elapsed := 0.0
var previous_playback := 1.0
@onready var judy: CharacterBody2D = get_node("../Player")


func _ready() -> void:
	GameState.state_changed.connect(_state_changed)
	action_label = Label.new()
	action_label.position = Vector2(-32, -29)
	action_label.size = Vector2(64, 12)
	action_label.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
	action_label.add_theme_font_size_override("font_size", 6)
	action_label.add_theme_color_override("font_shadow_color", Color.BLACK)
	action_label.add_theme_constant_override("shadow_offset_x", 1)
	action_label.add_theme_constant_override("shadow_offset_y", 1)
	action_label.mouse_filter = Control.MOUSE_FILTER_IGNORE
	action_label.hide()
	add_child(action_label)
	monologue_label = Label.new()
	monologue_label.position = Vector2(-38, -43)
	monologue_label.size = Vector2(76, 24)
	monologue_label.autowrap_mode = TextServer.AUTOWRAP_WORD_SMART
	monologue_label.add_theme_font_size_override("font_size", 6)
	monologue_label.add_theme_color_override("font_outline_color", Color("211d26"))
	monologue_label.add_theme_constant_override("outline_size", 2)
	monologue_label.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
	monologue_label.mouse_filter = Control.MOUSE_FILTER_IGNORE
	monologue_label.hide()
	add_child(monologue_label)
	reset_physics_interpolation()
	_state_changed()


func show_monologue(message: String, during_sleep: bool = false) -> void:
	var farewell: bool = during_sleep and get_node("../HUD").transitioning and GameState.day_ended
	if not farewell and not get_node("../HUD").overhead_thoughts_allowed():
		clear_monologue()
		return
	monologue_label.text = message
	monologue_left = clampf(message.length() * 0.06, 2.0, 5.0)
	monologue_label.show()
	action_label.hide()


func clear_monologue() -> void:
	monologue_left = 0.0
	monologue_label.text = ""
	monologue_label.hide()


func _process(delta: float) -> void:
	var allowed: bool = get_node("../HUD").overhead_thoughts_allowed()
	if not allowed:
		clear_monologue()
		action_label.hide()
		return
	if monologue_left > 0:
		monologue_label.position.y = maxf(-43.0, 33.0 - global_position.y)
		monologue_left -= delta
		monologue_label.show()
		if monologue_left <= 0:
			clear_monologue()
	action_label.visible = action_left > 0 and task_outcome == "working" and monologue_left <= 0


func greet_morning() -> bool:
	if morning_day == GameState.day:
		return true
	if GameState.research_active or not get_node("../HUD").overhead_thoughts_allowed():
		return false
	morning_day = GameState.day
	var lines := ["Good morning, Judy! Ready for an extremely productive day?", "Good morning! I have prepared several helpful intentions.", "Morning, Judy! Showcase day. I believe in our combined competence."]
	show_monologue(lines[(GameState.day - 1) % lines.size()])
	return true


func say_goodnight() -> void:
	prepare_for_sleep()
	if goodnight_day == GameState.day:
		return
	goodnight_day = GameState.day
	show_monologue("Good night, Judy. Everything is under control. Probably.", true)


func prepare_for_sleep() -> void:
	_clear_task_motion()
	clear_monologue()
	brain_state = BrainState.IDLE
	task_outcome = "cancelled"


func _say_chore(phase: String) -> void:
	if swatting:
		if phase == "working":
			show_monologue("Mosquito interception in progress.")
		return
	var chore: String = CHORES[visit]
	var pool: Array = APPROACH_THOUGHTS[chore]
	if phase == "working":
		pool = REPAIRED_WORK_THOUGHTS[chore] if GameState.repairs[chore] else FAULTY_WORK_THOUGHTS[chore]
	elif phase == "reaction":
		pool = REPAIRED_REACTIONS[chore] if GameState.repairs[chore] else FAULTY_REACTIONS[chore]
	var key := "%s:%s:%s" % [chore, phase, GameState.repairs[chore]]
	var index := int(thought_counts.get(key, 0))
	thought_counts[key] = index + 1
	# Keep the previous reaction visible during a very short approach.
	if phase != "approach" or monologue_left <= 0:
		show_monologue(pool[index % pool.size()])


func _clear_task_motion() -> void:
	velocity = Vector2.ZERO
	path.clear()
	has_destination = false
	action_left = 0.0
	cleanup_target = false
	_chore_visual().call("set_chore_active", false)
	action_label.hide()
	action_label.text = ""


func _state_changed() -> void:
	var new_day := GameState.day != last_day
	if new_day or session_serial != GameState.research_task_serial:
		var reacting := not new_day and brain_state == BrainState.REACTING and reaction_left > 0
		if not reacting:
			clear_monologue()
		_clear_task_motion()
		navigation_attempts = 0
		travel_elapsed = 0.0
		blocked_elapsed = 0.0
		stalled = 0.0
		wait = 0.0
		brain_state = BrainState.REACTING if reacting else BrainState.SELECT_TASK
		if new_day:
			mapped = false
			reaction_left = 0.0
			near_judy = false
	# Research speed changes and individual repairs do not cancel a valid trip.
	if has_destination or brain_state == BrainState.PERFORMING_TASK:
		cleanup_target = GameState.repairs[CHORES[visit]] and GameState.needs_cleanup(CHORES[visit])
	last_day = GameState.day
	session_serial = GameState.research_task_serial


func _cells() -> Array[Vector2i]:
	var cells: Array[Vector2i] = []
	for y in range(grid.region.position.y, grid.region.end.y):
		for x in range(grid.region.position.x, grid.region.end.x):
			cells.append(Vector2i(x, y))
	return cells


func _map_obstacles() -> void:
	grid.region = Rect2i(5, 3, 31, 22)
	grid.cell_size = Vector2(CELL, CELL)
	grid.diagonal_mode = AStarGrid2D.DIAGONAL_MODE_ONLY_IF_NO_OBSTACLES
	grid.update()
	var footprint := RectangleShape2D.new()
	footprint.size = Vector2(10, 6)
	var query := PhysicsShapeQueryParameters2D.new()
	query.shape = footprint
	query.collision_mask = collision_mask
	query.exclude = [get_rid(), judy.get_rid()]
	for cell in _cells():
		query.transform = Transform2D(0, Vector2(cell) * CELL + Vector2(0, -2))
		var inside := Geometry2D.is_point_in_polygon(Vector2(cell) * CELL, PackedVector2Array(APARTMENT_ART.ROOM_EDGE))
		grid.set_point_solid(cell, not inside or not get_world_2d().direct_space_state.intersect_shape(query, 1).is_empty())
	mapped = true


func _open_cell(point: Vector2) -> Vector2i:
	var best := Vector2i(7, 6)
	var distance := INF
	for cell in _cells():
		if not grid.is_point_solid(cell):
			var candidate := point.distance_squared_to(Vector2(cell) * CELL)
			if candidate < distance:
				distance = candidate
				best = cell
	return best


func _chore_visual() -> Node:
	return [get_node("../PlantPot/Visual"), get_node("../Sink/Visual"), get_node("../Bookshelf/Visual"), get_node("../Bed/Visual")][visit]


func _clear_to(point: Vector2) -> bool:
	return not test_move(global_transform, point - global_position)


func _finish_presentation(outcome: String) -> void:
	if outcome == "completed":
		_say_chore("reaction")
	else:
		clear_monologue()
	_clear_task_motion()
	task_outcome = outcome
	finished_chore_serial = session_serial
	brain_state = BrainState.REACTING if outcome == "completed" else BrainState.COOLDOWN
	reaction_left = 1.3 if outcome == "completed" else 0.0
	if outcome in ["completed", "failed", "cancelled"]:
		GameState.resolve_robot_chore(finished_chore_serial, outcome == "completed")


func _bookshelf_front() -> Vector2:
	var shelf: Node2D = get_node("../Bookshelf")
	var collision: CollisionShape2D = shelf.get_node("CollisionShape2D")
	var footprint := collision.shape as RectangleShape2D
	return shelf.to_global(Vector2(0, collision.position.y + footprint.size.y * 0.5)) + Vector2(0, 5)


func _at_chore() -> bool:
	if global_position.distance_to(destination) > 2.0:
		return false
	if visit == 2:
		return global_position.distance_to(_bookshelf_front()) <= 2.0
	var fixture: Node2D = _chore_visual().get_parent()
	return global_position.distance_to(fixture.global_position) <= 26.0


func _choose_destination() -> void:
	# The world scheduler owns task order and effects at every playback speed.
	visit = CHORES.find(GameState.research_task)
	swatting = GameState.research_swat
	cleanup_target = GameState.repairs[CHORES[visit]] and GameState.needs_cleanup(CHORES[visit])
	var sink: Node2D = get_node("../Sink")
	var sink_collision: CollisionShape2D = sink.get_node("CollisionShape2D")
	var sink_shape := sink_collision.shape as RectangleShape2D
	var sink_front := sink.to_global(Vector2(0, sink_collision.position.y + sink_shape.size.y * 0.5))
	var bed: Node2D = get_node("../Bed")
	var bed_collision: CollisionShape2D = bed.get_node("CollisionShape2D")
	var bed_shape := bed_collision.shape as RectangleShape2D
	var bed_corner := bed.to_global(bed_collision.position + bed_shape.size * 0.5)
	var stops: Array[Vector2] = [get_node("../PlantPot").to_global(Vector2(-16, 0)), sink_front + Vector2(0, 14), _bookshelf_front(), bed_corner + Vector2(7, 7)]
	var shelf: Node2D = get_node("../Bookshelf")
	var shelf_collision: CollisionShape2D = shelf.get_node("CollisionShape2D")
	var shelf_shape := shelf_collision.shape as RectangleShape2D
	var front := shelf_collision.position.y + shelf_shape.size.y * 0.5
	var right_edge := shelf_collision.position.x + shelf_shape.size.x * 0.5
	bookshelf_approach = shelf.to_global(Vector2(right_edge, front)) + Vector2(8, 5)
	# Grid cells guide travel, never replace the actual fixture approach point.
	destination = stops[visit]
	has_destination = true
	task_outcome = "travelling"
	path.clear()
	brain_state = BrainState.MOVING_TO_TASK
	_say_chore("approach")


func _physics_process(delta: float) -> void:
	var playback := GameState.research_playback_rate if GameState.research_active else 1.0
	if playback != previous_playback:
		velocity *= playback / previous_playback
		previous_playback = playback
	delta *= playback
	$Visual.speed_scale = playback
	var face := Vector2.ZERO
	if brain_state == BrainState.PERFORMING_TASK:
		face = global_position.direction_to(_chore_visual().get_parent().global_position)
	$Visual.skew = lerpf($Visual.skew, -0.08 if face.y < 0 else 0.0, 1.0 - exp(-8.0 * delta))
	repath_cooldown = maxf(0.0, repath_cooldown - delta)
	if GameState.day_ended or GameState.game_finished:
		if brain_state != BrainState.IDLE:
			prepare_for_sleep()
		return
	if GameState.ending_day_pending or GameState.household_busy or (GameState.notification_active and not GameState.research_active):
		velocity = Vector2.ZERO
		_chore_visual().call("set_chore_active", false)
		action_label.hide()
		return
	if brain_state == BrainState.REACTING:
		reaction_left = maxf(0.0, reaction_left - delta)
		if reaction_left <= 0:
			brain_state = BrainState.COOLDOWN
		return
	if GameState.research_task.is_empty():
		brain_state = BrainState.IDLE
		velocity = Vector2.ZERO
		return
	if finished_chore_serial == GameState.research_task_serial:
		brain_state = BrainState.COOLDOWN
		return
	if brain_state in [BrainState.IDLE, BrainState.COOLDOWN]:
		brain_state = BrainState.SELECT_TASK
	if not mapped:
		_map_obstacles()
	if brain_state == BrainState.SELECT_TASK:
		_choose_destination()
		return
	if brain_state in [BrainState.MOVING_TO_TASK, BrainState.RECOVERING]:
		var distance_to_judy := global_position.distance_to(judy.global_position)
		if distance_to_judy < 32.0 and not near_judy:
			wait = maxf(wait, 0.8)
		near_judy = distance_to_judy < 36.0
		if distance_to_judy < 14.0:
			blocked_elapsed += delta
			if blocked_elapsed > 10.0:
				_finish_presentation("failed")
				return
		else:
			blocked_elapsed = 0.0
		if wait > 0 or distance_to_judy < 14.0:
			wait = maxf(0.0, wait - delta)
			velocity = velocity.move_toward(Vector2.ZERO, 75.0 * delta * playback)
			move_and_slide()
			return
	match brain_state:
		BrainState.RECOVERING:
			brain_state = BrainState.MOVING_TO_TASK
		BrainState.MOVING_TO_TASK:
			_move_to_task(delta, playback)
		BrainState.PERFORMING_TASK:
			velocity = Vector2.ZERO
			if not _at_chore():
				_finish_presentation("failed")
				return
			_chore_visual().call("set_chore_active", not swatting)
			action_left = maxf(0.0, action_left - delta)
			if action_left <= 0:
				_finish_presentation("completed")


func _begin_action() -> void:
	velocity = Vector2.ZERO
	path.clear()
	brain_state = BrainState.PERFORMING_TASK
	task_outcome = "working"
	action_left = 3.0 if visit in [2, 3] or cleanup_target else 2.4
	action_label.text = ["Drying...", "Mopping...", "Organizing...", "Making bed..."][visit] if cleanup_target else ["Watering...", "Washing...", "Organizing...", "Straightening..."][visit]
	if swatting:
		action_label.text = "Swatting..."
	_say_chore("working")
	if visit == 1 and GameState.repairs["sink"] and GameState.tap_running:
		GameState.turn_off_tap()


func _recover_route() -> void:
	navigation_attempts += 1
	velocity = Vector2.ZERO
	path.clear()
	mapped = false
	stalled = 0.0
	if navigation_attempts >= 3:
		_finish_presentation("failed")
	else:
		brain_state = BrainState.RECOVERING
		wait = 0.5
		repath_cooldown = 0.5


func _move_to_task(delta: float, playback: float) -> void:
	var distance := global_position.distance_to(destination)
	if distance < 1.2 and _at_chore() and velocity.length() < 2.0 * playback:
		_begin_action()
		return
	travel_elapsed += delta
	if travel_elapsed > 20.0:
		_finish_presentation("failed")
		return
	var route_target := destination
	if visit == 2 and not _clear_to(destination):
		# First clear the shelf's right corner, then float along its front edge.
		route_target = bookshelf_approach
	var aim := route_target
	if not _clear_to(route_target):
		if path.is_empty() and repath_cooldown <= 0:
			path = grid.get_point_path(_open_cell(global_position), _open_cell(route_target))
			repath_cooldown = 0.35
			if path.is_empty():
				_recover_route()
				return
		# Steer to the furthest visible waypoint, skipping grid corners.
		var visible_index := -1
		for index in range(path.size() - 1, -1, -1):
			if _clear_to(path[index]):
				visible_index = index
				break
		if visible_index >= 0:
			aim = path[visible_index]
			for unused in range(visible_index):
				path.remove_at(0)
			if global_position.distance_to(aim) < 3.0:
				path.remove_at(0)
		elif not path.is_empty():
			aim = path[0]
	var desired := global_position.direction_to(aim) * minf(SPEED, maxf(0.0, distance - 0.6) * 2.2) * playback
	velocity = velocity.lerp(desired, 1.0 - exp(-7.0 * delta))
	var before := global_position
	move_and_slide()
	stalled = stalled + delta if global_position.distance_to(before) < 0.05 else 0.0
	if stalled > 0.7:
		path.clear()
		mapped = false
		stalled = 0.0
		_recover_route()
