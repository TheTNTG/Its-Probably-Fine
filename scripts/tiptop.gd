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
var leaving_bookshelf := false
var has_destination := false
var action_left := 0.0
var near_judy := false
var repath_cooldown := 0.0
var action_label: Label
var monologue_label: Label
var monologue_left := 0.0
var thought_layer: CanvasLayer
var thought_anchor := Vector2.ZERO
const THOUGHT_SIZE := Vector2(76, 24)
const THOUGHT_LIMIT := 56
const CHORES := ["plant", "sink", "bookshelf", "bed"]
enum BrainState { IDLE, SELECT_TASK, MOVING_TO_TASK, PERFORMING_TASK, REACTING, COOLDOWN, RECOVERING }
var brain_state := BrainState.IDLE
var reaction_left := 0.0
var blocked_elapsed := 0.0
var morning_day := 0
var goodnight_day := 0
var thought_counts: Dictionary = {}
const APPROACH_THOUGHTS := {
	"sink": ["These dishes deserve a fresh start.", "Dish duty is one of my four specialties."],
	"plant": ["I shall check on our leafy colleague.", "The plant has silently requested my attention."],
	"bookshelf": ["The bookshelf requires my expertise.", "These books have rectangular potential."],
	"bed": ["A tidy bed supports untidy scientific ideas.", "I shall assess the sheet situation."]
}
const FAULTY_WORK_THOUGHTS := {
	"sink": ["Maximum cleanliness requires maximum water!", "A continuous rinse must be very thorough."],
	"plant": ["Plants love water. More must be better!", "A generous drink for a generous plant."],
	"bookshelf": ["The largest books belong on top.", "I am testing an aerodynamic arrangement."],
	"bed": ["Every sheet deserves extra ventilation!", "A little creative folding should help."]
}
const REPAIRED_WORK_THOUGHTS := {
	"sink": ["I shall rinse the dishes, then close the tap.", "I have revised my rinsing methods."],
	"plant": ["I shall give it just enough water.", "I shall check the soil before I pour."],
	"bookshelf": ["The titles belong in order, spines facing out.", "Upright books are an elegant solution."],
	"bed": ["I shall tuck the corners and restore the pillow.", "I remember to smooth the sheets gently."]
}
const FAULTY_REACTIONS := {
	"sink": ["The dish cycle was successful.", "The water is certainly flowing efficiently."],
	"plant": ["Hydration is complete.", "Our colleague will be delighted."],
	"bookshelf": ["This bold new arrangement is excellent.", "I have optimized the book order."],
	"bed": ["The sheets are thoroughly aerated.", "This bed is refreshingly unconventional."]
}
const REPAIRED_REACTIONS := {
	"sink": ["The dishes are clean and the floor is dry.", "That was another successful chore!"],
	"plant": ["I delivered the correct amount this time.", "The plant is healthy and the floor is dry."],
	"bookshelf": ["The books are alphabetical and upright.", "Everything is in its place, even the books."],
	"bed": ["The bed is made. I shall leave it made.", "The bed is ready for sleeping or admiring."]
}
var cleanup_target := false
var swatting := false
var swat_target := -1
var target_refresh := 0.0
var batch_elapsed := 0.0
var logical_motion := false
var display_position := Vector2.ZERO
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
	action_label.add_theme_font_size_override("font_size", 5)
	action_label.add_theme_color_override("font_shadow_color", Color.BLACK)
	action_label.add_theme_constant_override("shadow_offset_x", 1)
	action_label.add_theme_constant_override("shadow_offset_y", 1)
	action_label.mouse_filter = Control.MOUSE_FILTER_IGNORE
	action_label.hide()
	# One screen-space bubble: the status is only a fallback, never a second line.
	thought_layer = CanvasLayer.new()
	thought_layer.layer = 1
	add_child(thought_layer)
	thought_layer.add_child(action_label)
	monologue_label = Label.new()
	monologue_label.position = Vector2(-38, -43)
	monologue_label.size = Vector2(76, 24)
	monologue_label.autowrap_mode = TextServer.AUTOWRAP_WORD_SMART
	monologue_label.add_theme_font_size_override("font_size", 5)
	monologue_label.add_theme_color_override("font_outline_color", Color("211d26"))
	monologue_label.add_theme_constant_override("outline_size", 2)
	monologue_label.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
	monologue_label.mouse_filter = Control.MOUSE_FILTER_IGNORE
	monologue_label.hide()
	thought_layer.add_child(monologue_label)
	var bubble := StyleBoxFlat.new()
	bubble.bg_color = Color(0.10, 0.14, 0.17, 0.94)
	bubble.set_corner_radius_all(3)
	bubble.content_margin_left = 4
	bubble.content_margin_right = 4
	bubble.content_margin_top = 2
	bubble.content_margin_bottom = 2
	for label in [action_label, monologue_label]:
		label.texture_filter = CanvasItem.TEXTURE_FILTER_LINEAR
		label.autowrap_mode = TextServer.AUTOWRAP_WORD_SMART
		label.max_lines_visible = 3
		label.text_overrun_behavior = TextServer.OVERRUN_TRIM_ELLIPSIS
		label.clip_text = true
		label.vertical_alignment = VERTICAL_ALIGNMENT_CENTER
		label.add_theme_stylebox_override("normal", bubble)
		label.add_theme_constant_override("outline_size", 0)
		label.add_theme_constant_override("line_spacing", 0)
		label.size = THOUGHT_SIZE
	reset_physics_interpolation()
	_state_changed()


func show_monologue(message: String, during_sleep: bool = false) -> void:
	if GameState.activity_skip_busy:
		clear_monologue()
		return
	if message.length() > THOUGHT_LIMIT:
		# Long conversations use the existing safe comic queue, never a tall bubble.
		get_node("../HUD")._show_feedback("TipTop: " + message)
		return
	var farewell: bool = during_sleep and get_node("../HUD").transitioning and GameState.day_ended
	if not farewell and not get_node("../HUD").overhead_thoughts_allowed():
		clear_monologue()
		return
	monologue_label.text = _thought_line_breaks(message)
	monologue_left = clampf(message.length() * 0.06, 2.0, 5.0)
	monologue_label.show()
	action_label.hide()
	_position_thought()


func clear_monologue() -> void:
	monologue_left = 0.0
	monologue_label.text = ""
	monologue_label.hide()


func _process(delta: float) -> void:
	if not GameState.personal_activity.is_empty():
		if display_position.distance_to(global_position) > 60:
			display_position = global_position
		display_position = display_position.lerp(global_position, 1.0 - exp(-12 * delta))
		$Visual.position = Vector2(0, -9) + display_position - global_position
	else:
		display_position = global_position
		$Visual.position = Vector2(0, -9)
	var allowed: bool = get_node("../HUD").overhead_thoughts_allowed()
	if not allowed:
		clear_monologue()
		action_label.hide()
		return
	if monologue_left > 0:
		monologue_left -= delta
		monologue_label.show()
		if monologue_left <= 0:
			clear_monologue()
	action_label.visible = action_left > 0 and task_outcome == "working" and monologue_left <= 0
	_position_thought()


func _thought_line_breaks(message: String) -> String:
	var font := monologue_label.get_theme_font("font")
	var rows: Array[String] = []
	var row := ""
	for word in message.split(" ", false):
		var candidate := word if row.is_empty() else row + " " + word
		if not row.is_empty() and font.get_string_size(candidate, HORIZONTAL_ALIGNMENT_LEFT, -1, 5).x > THOUGHT_SIZE.x - 8:
			rows.append(row)
			row = word
		else:
			row = candidate
	rows.append(row)
	return "\n".join(rows)


func _position_thought() -> void:
	var hud: CanvasLayer = get_node("../HUD")
	thought_layer.transform = hud.transform
	var to_ui: Transform2D = hud.transform.affine_inverse()
	var feet: Vector2 = to_ui * get_global_transform_with_canvas().origin
	if thought_anchor.distance_to(feet) > 40.0:
		thought_anchor = feet
	else:
		thought_anchor = thought_anchor.lerp(feet, 1.0 - exp(-20.0 * get_process_delta_time()))
	feet = thought_anchor
	var active: Label = monologue_label if monologue_left > 0 else action_label
	var font := active.get_theme_font("font")
	var rows := active.text.split("\n")
	var width := 0.0
	for row in rows:
		width = maxf(width, font.get_string_size(row, HORIZONTAL_ALIGNMENT_LEFT, -1, 5).x)
	var bubble_size := Vector2(ceilf(width) + 8, ceilf(font.get_height(5)) * rows.size() + 4)
	var pos: Vector2 = feet + Vector2(-bubble_size.x * 0.5, -20 - bubble_size.y)
	# HUD reference space is fitted uniformly inside every supported viewport.
	pos = pos.clamp(Vector2(6, 44), Vector2(326, 238) - bubble_size)
	for label in [action_label, monologue_label]:
		label.position = pos
		label.size = bubble_size


func greet_morning() -> bool:
	if morning_day == GameState.day:
		return true
	if GameState.research_active or not get_node("../HUD").overhead_thoughts_allowed():
		return false
	morning_day = GameState.day
	var lines := ["Good morning, Judy! I've prepared a perfectly organized day.", "Good morning, Judy! I have several helpful intentions.", "Good morning, Judy! It's showcase day. I believe in us."]
	var hud = get_node("../HUD")
	hud.dialogue_lines.append_array([["TipTop", lines[(GameState.day - 1) % lines.size()], "proud"], ["Judy", "That sounds suspiciously optimistic.", "neutral"]])
	hud._advance_dialogue()
	return true


func say_goodnight() -> void:
	prepare_for_sleep()
	if goodnight_day == GameState.day:
		return
	goodnight_day = GameState.day
	var hud = get_node("../HUD")
	hud.dialogue_lines.append_array([["TipTop", "Good night, Judy. Everything is under control. Probably.", "neutral"], ["Judy", "That's exactly what worries me. Night, TipTop.", "happy"]])
	hud._advance_dialogue()


func prepare_for_sleep() -> void:
	_clear_task_motion()
	clear_monologue()
	brain_state = BrainState.IDLE
	task_outcome = "cancelled"


func _say_chore(phase: String) -> void:
	if swatting:
		if phase == "approach":
			show_monologue("Tiny airborne intruder detected.")
		elif phase == "working":
			show_monologue("I have the situation under control.")
		elif phase == "reaction":
			show_monologue("One less mosquito. You're welcome, Judy." if GameState.batch_removed == 1 else "I removed %d airborne intruders." % GameState.batch_removed)
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
	show_monologue(pool[index % pool.size()])


func _clear_task_motion() -> void:
	velocity = Vector2.ZERO
	path.clear()
	has_destination = false
	leaving_bookshelf = false
	destination = Vector2.ZERO
	action_left = 0.0
	cleanup_target = false
	_chore_visual().call("set_chore_active", false)
	action_label.hide()
	action_label.text = ""


func _state_changed() -> void:
	var new_day := GameState.day != last_day
	if new_day or session_serial != GameState.research_task_serial:
		batch_elapsed = 0.0
		var reacting := not new_day and brain_state == BrainState.REACTING and reaction_left > 0
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
	if outcome == "completed" and swatting and not GameState.eliminate_mosquito(swat_target, global_position):
		outcome = "failed"
	if swatting:
		if outcome == "completed":
			GameState.batch_removed += 1
		GameState.mosquito_batch.erase(swat_target)
		while not GameState.mosquito_batch.is_empty() and not GameState.mosquitoes.has(GameState.mosquito_batch[0]):
			GameState.mosquito_batch.pop_front()
		if not GameState.mosquito_batch.is_empty() and GameState.batch_removed < 3 and batch_elapsed < 30.0:
			GameState.mosquito_target_id = int(GameState.mosquito_batch[0])
			_clear_task_motion()
			clear_monologue()
			navigation_attempts = 0
			travel_elapsed = 0.0
			blocked_elapsed = 0.0
			stalled = 0.0
			brain_state = BrainState.SELECT_TASK
			return
		if GameState.batch_removed > 0:
			outcome = "completed"
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


func _bookshelf_exit() -> Vector2:
	var shelf: Node2D = get_node("../Bookshelf")
	var collision: CollisionShape2D = shelf.get_node("CollisionShape2D")
	var footprint := collision.shape as RectangleShape2D
	return shelf.to_global(collision.position + footprint.size * 0.5) + Vector2(8, 5)


func _at_chore() -> bool:
	if swatting:
		return GameState.mosquitoes.has(swat_target) and global_position.distance_to(GameState.mosquitoes[swat_target]["position"]) <= 9.0
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
	bookshelf_approach = _bookshelf_exit()
	# Grid cells guide travel, never replace the actual fixture approach point.
	destination = stops[visit]
	if swatting:
		swat_target = GameState.mosquito_target_id
		if not GameState.mosquitoes.has(swat_target):
			_finish_presentation("cancelled")
			return
		destination = GameState.mosquitoes[swat_target]["position"]
		target_refresh = 0.0
	# The shelf-to-wall strip has no grid row. Use its exact connector in BOTH
	# directions; snapping the starting point to the grid would cut through books.
	var front := _bookshelf_front()
	leaving_bookshelf = visit != 2 and global_position.x < bookshelf_approach.x and absf(global_position.y - front.y) < 3.0 and not _clear_to(destination)
	has_destination = true
	task_outcome = "travelling"
	path.clear()
	brain_state = BrainState.MOVING_TO_TASK
	_say_chore("approach")


func _physics_process(delta: float) -> void:
	if not GameState.personal_activity.is_empty():
		return # The same world-step callback owns Watch, 6x and instant Skip.
	_tick_ai(delta, GameState.research_playback_rate if GameState.research_active else 1.0)


func advance_activity_ai(seconds: float) -> void:
	logical_motion = true
	_tick_ai(seconds, 1.0)
	logical_motion = false


func _move_actor(delta: float, playback: float) -> void:
	if not logical_motion:
		move_and_slide()
		return
	var collision := move_and_collide(velocity * delta / playback)
	if collision:
		move_and_collide(collision.get_remainder().slide(collision.get_normal()))


func _tick_ai(delta: float, playback: float) -> void:
	# Covers ordinary movement, Watch/6x and world-step Skip simulation.
	if not GameState.tutorial_finished:
		velocity = Vector2.ZERO
		return
	if playback != previous_playback:
		velocity *= playback / previous_playback
		previous_playback = playback
	delta *= playback
	$Visual.speed_scale = playback
	var face := Vector2.ZERO
	if brain_state == BrainState.PERFORMING_TASK:
		if swatting and GameState.mosquitoes.has(swat_target):
			face = global_position.direction_to(GameState.mosquitoes[swat_target]["position"])
		else:
			face = global_position.direction_to(_chore_visual().get_parent().global_position)
	$Visual.skew = lerpf($Visual.skew, -0.08 if face.y < 0 else 0.0, 1.0 - exp(-8.0 * delta))
	repath_cooldown = maxf(0.0, repath_cooldown - delta)
	if swatting and brain_state in [BrainState.MOVING_TO_TASK, BrainState.PERFORMING_TASK, BrainState.RECOVERING]:
		batch_elapsed += delta
		if batch_elapsed > 30.0:
			_finish_presentation("failed")
			return
		if not GameState.mosquitoes.has(swat_target):
			_finish_presentation("cancelled")
			return
		target_refresh -= delta
		if target_refresh <= 0 and brain_state != BrainState.PERFORMING_TASK:
			var point: Vector2 = GameState.mosquitoes[swat_target]["position"]
			if destination.distance_to(point) > 3:
				destination = point
				path.clear()
			target_refresh = 0.6
	if GameState.day_ended or GameState.game_finished:
		if brain_state != BrainState.IDLE:
			prepare_for_sleep()
		return
	if GameState.ending_day_pending or GameState.household_busy or (GameState.notification_active and not GameState.research_active and GameState.personal_activity.is_empty()):
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
			_move_actor(delta, playback)
			return
	match brain_state:
		BrainState.RECOVERING:
			brain_state = BrainState.MOVING_TO_TASK
		BrainState.MOVING_TO_TASK:
			_move_to_task(delta, playback)
		BrainState.PERFORMING_TASK:
			velocity = Vector2.ZERO
			travel_elapsed += delta
			if not _at_chore() or travel_elapsed > 6.0:
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
	travel_elapsed = 0.0
	task_outcome = "working"
	action_left = 3.0 if visit in [2, 3] or cleanup_target else 2.4
	action_label.text = ["Drying...", "Mopping...", "Organizing...", "Making bed..."][visit] if cleanup_target else ["Watering...", "Washing...", "Organizing...", "Straightening..."][visit]
	if swatting:
		action_label.text = "Swatting..."
		action_left = 0.4
	_say_chore("working")
	if not swatting and visit == 1 and GameState.repairs["sink"] and GameState.tap_running:
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
	if swatting and _at_chore():
		_begin_action()
		return
	if distance < 1.2 and _at_chore() and velocity.length() < 2.0 * playback:
		_begin_action()
		return
	travel_elapsed += delta
	if travel_elapsed > 20.0:
		_finish_presentation("failed")
		return
	var route_target := destination
	if leaving_bookshelf:
		if global_position.distance_to(bookshelf_approach) < 1.5:
			leaving_bookshelf = false
			path.clear()
		else:
			route_target = bookshelf_approach
	elif visit == 2 and not _clear_to(destination):
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
		else:
			# No visible connection to the grid: recover, never steer through a solid.
			_recover_route()
			return
	var aim_distance := global_position.distance_to(aim)
	var desired := global_position.direction_to(aim) * minf(SPEED, maxf(0.0, aim_distance - 0.6) * 2.2) * playback
	velocity = velocity.lerp(desired, 1.0 - exp(-7.0 * delta))
	var before := global_position
	_move_actor(delta, playback)
	stalled = stalled + delta if global_position.distance_to(before) < 0.05 else 0.0
	if stalled > 0.7:
		path.clear()
		mapped = false
		stalled = 0.0
		_recover_route()
