extends CharacterBody2D

const SPEED := 28.0
const CELL := 8.0
var grid := AStarGrid2D.new()
var path := PackedVector2Array()
var visit := 0
var wait := 0.0
var stalled := 0.0
var mapped := false
var last_day := 1
var was_fixed := false
var destination := Vector2.ZERO
var has_destination := false
var action_left := 0.0
var near_judy := false
var reaction_day := 0
var repath_cooldown := 0.0
var action_label: Label
var monologue_label: Label
var monologue_left := 0.0
const CHORES := ["plant", "sink", "bookshelf", "bed"]
var repair_count := 0
var cleanup_target := false
var swatting := false
var session_serial := -1
var was_research := false
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


func show_monologue(message: String) -> void:
	monologue_label.text = message
	monologue_left = clampf(message.length() * 0.06, 2.0, 5.0)
	monologue_label.show()


func _process(delta: float) -> void:
	if monologue_left > 0:
		monologue_label.position.y = maxf(-43.0, 33.0 - global_position.y)
		monologue_left -= delta
		monologue_label.visible = not get_node("../HUD").dialogue_overlay.visible
		if monologue_left <= 0:
			monologue_label.hide()


func _state_changed() -> void:
	if GameState.repairs.values().count(true) != repair_count or GameState.day != last_day or was_research != GameState.research_active or (GameState.research_active and session_serial != GameState.research_task_serial):
		wait = 0.8
		path.clear()
		has_destination = false
		action_left = 0.0
		_chore_visual().call("set_chore_active", false)
		action_label.hide()
		velocity = Vector2.ZERO
	was_fixed = GameState.tiptop_fixed
	last_day = GameState.day
	repair_count = GameState.repairs.values().count(true)
	session_serial = GameState.research_task_serial
	was_research = GameState.research_active


func _cells() -> Array[Vector2i]:
	var cells: Array[Vector2i] = []
	for y in range(grid.region.position.y, grid.region.end.y):
		for x in range(grid.region.position.x, grid.region.end.x):
			cells.append(Vector2i(x, y))
	return cells


func _map_obstacles() -> void:
	grid.region = Rect2i(7, 6, 27, 15)
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
		grid.set_point_solid(cell, not get_world_2d().direct_space_state.intersect_shape(query, 1).is_empty())
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


func _choose_destination() -> void:
	cleanup_target = false
	swatting = GameState.mosquito_task and GameState.mosquito_level > 0
	for index in [2, 3, 1, 0]:
		if GameState.repairs[CHORES[index]] and GameState.needs_cleanup(CHORES[index]):
			visit = index
			cleanup_target = true
			break
	if swatting:
		visit = 1 if GameState.sink_water_elapsed >= 8.0 else 0
		cleanup_target = false
	if GameState.research_active:
		visit = CHORES.find(GameState.research_task)
		swatting = GameState.research_swat
		cleanup_target = GameState.repairs[CHORES[visit]] and GameState.needs_cleanup(CHORES[visit])
	var stops: Array[Vector2] = [get_node("../PlantPot").global_position + Vector2(-16, 0), get_node("../Sink").global_position + Vector2(0, 14), get_node("../Bookshelf").global_position + Vector2(22, 0), get_node("../Bed").global_position + Vector2(22, 7)]
	# Small variations keep repeated visits from looking like a fixed rail.
	var candidate := stops[visit]
	if not GameState.research_active:
		candidate += Vector2(randf_range(-3, 3), randf_range(-2, 2))
	destination = Vector2(_open_cell(candidate)) * CELL
	if _clear_to(candidate):
		destination = candidate
	has_destination = true
	path.clear()


func _physics_process(delta: float) -> void:
	var playback := GameState.research_playback_rate if GameState.research_active else 1.0
	if playback != previous_playback:
		velocity *= playback / previous_playback
		previous_playback = playback
	delta *= playback
	$Visual.speed_scale = playback
	repath_cooldown = maxf(0.0, repath_cooldown - delta)
	if GameState.day_ended or GameState.game_finished or GameState.ending_day_pending or GameState.household_busy:
		velocity = Vector2.ZERO
		_chore_visual().call("set_chore_active", false)
		return
	if not mapped:
		_map_obstacles()
	if cleanup_target and not GameState.needs_cleanup(CHORES[visit]):
		_chore_visual().call("set_chore_active", false)
		action_left = 0
		has_destination = false
		cleanup_target = false
		path.clear()
		action_label.hide()
		visit = (visit + 1) % 4
	var distance_to_judy := global_position.distance_to(judy.global_position)
	if distance_to_judy < 32.0 and not near_judy:
		wait = maxf(wait, 0.8)
	near_judy = distance_to_judy < 36.0
	if wait > 0 or distance_to_judy < 14.0:
		wait = maxf(0, wait - delta)
		velocity = velocity.move_toward(Vector2.ZERO, 75.0 * delta * playback)
		move_and_slide()
		_chore_visual().call("set_chore_active", false)
		return
	if action_left > 0:
		velocity = Vector2.ZERO
		_chore_visual().call("set_chore_active", not swatting)
		action_left -= delta
		if action_left <= 0:
			if GameState.research_active:
				# Presentation waits here; the shared session scheduler owns effects.
				action_left = 0.2
				return
			_chore_visual().call("set_chore_active", false)
			if swatting:
				GameState.swat_mosquitoes(false)
				swatting = false
			else:
				GameState.finish_household_chore(CHORES[visit])
			if not GameState.repairs[CHORES[visit]] and reaction_day != GameState.day:
				GameState.action_feedback.emit("TipTop: " + ["Hydration complete.", "Dish cycle successful.", "Book order optimized.", "Sheets aerated."][visit])
				action_label.hide()
				reaction_day = GameState.day
			else:
				action_label.hide()
			cleanup_target = false
			visit = (visit + randi_range(1, 3)) % 4
			has_destination = false
			wait = randf_range(0.4, 1.2)
		return
	if not has_destination:
		action_label.hide()
		_choose_destination()
	var distance := global_position.distance_to(destination)
	if distance < 1.2 and velocity.length() < 2.0 * playback:
		velocity = Vector2.ZERO
		if not GameState.research_active and visit == 1 and GameState.repairs["sink"] and GameState.tap_running:
			GameState.turn_off_tap()
		action_left = 2.5 if cleanup_target or GameState.research_active else randf_range(1.5, 2.5)
		action_label.text = ["Drying...", "Mopping...", "Organizing...", "Making bed..."][visit] if cleanup_target else ["Watering...", "Washing...", "Sorting...", "Straightening..."][visit]
		action_label.show()
		if swatting:
			action_label.text = "Swatting..."
		return
	var aim := destination
	if not _clear_to(destination):
		if path.is_empty() and repath_cooldown <= 0:
			path = grid.get_point_path(_open_cell(global_position), _open_cell(destination))
			repath_cooldown = 0.35
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
		has_destination = false
		stalled = 0.0
		visit = (visit + 1) % 4
		wait = 0.3
