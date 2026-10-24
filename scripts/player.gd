extends CharacterBody2D

const SPEED := 80.0
const INTERACTION_DISTANCE := 32.0

@onready var visual: AnimatedSprite2D = $Visual

@onready var desk: Node2D = get_node("../Desk")
@onready var tiptop: Node2D = get_node("../TipTop")
@onready var sink: Node2D = get_node("../Sink")
@onready var bed: Node2D = get_node("../Bed")
@onready var plant: Node2D = get_node("../PlantPot")
@onready var bookshelf: Node2D = get_node("../Bookshelf")
@onready var fridge: Node2D = get_node("../Fridge")
var interaction_prompt: Label
var prompt_target: Node2D
var animation_busy := false
var sleep_blanket: ColorRect
var research_fast_forward := false


func _ready() -> void:
	var prompt_layer := CanvasLayer.new()
	prompt_layer.layer = 0
	add_child(prompt_layer)
	interaction_prompt = Label.new()
	interaction_prompt.texture_filter = CanvasItem.TEXTURE_FILTER_LINEAR
	interaction_prompt.add_theme_font_size_override("font_size", 6)
	interaction_prompt.mouse_filter = Control.MOUSE_FILTER_IGNORE
	var background := StyleBoxFlat.new()
	background.set_corner_radius_all(3)
	background.border_color = Color("b68b4c")
	background.set_border_width_all(1)
	background.bg_color = Color(0.12, 0.11, 0.14, 0.94)
	background.content_margin_left = 3
	background.content_margin_right = 3
	background.content_margin_top = 2
	background.content_margin_bottom = 2
	interaction_prompt.add_theme_stylebox_override("normal", background)
	prompt_layer.add_child(interaction_prompt)
	interaction_prompt.hide()
	# Refresh after TipTop's bubble, once per rendered frame.
	process_priority = 1
	GameState.story_event.connect(func(_event: String): interaction_prompt.hide())


func _update_interaction_prompt(target: Node2D) -> void:
	desk.get_node("PromptLabel").hide()
	if target == null or get_tree().paused or GameState.notification_active:
		interaction_prompt.hide()
		return
	interaction_prompt.modulate = Color.WHITE
	if target == desk:
		var exhausted := GameState.work_sessions_remaining <= 0
		interaction_prompt.text = "Too exhausted to work" if exhausted else "E - Work"
		interaction_prompt.modulate = Color.RED if exhausted else Color.GREEN
		if not GameState.research_available() and not exhausted:
			interaction_prompt.text = "E - Take a break first" if not GameState.mood_allows_research() else ("E - Research blocked (bookshelf)" if GameState.has_research_time() else "E - Not enough research time")
			interaction_prompt.modulate = Color.RED
	elif target == tiptop:
		interaction_prompt.text = "E - Talk to TipTop" if GameState.tiptop_fixed else "E - Talk / Repair TipTop"
	elif target == fridge:
		interaction_prompt.text = "E - Eat (30 min)"
	elif target == sink:
		interaction_prompt.text = "E - Tap off" if GameState.tap_running else "E - Mop / clean (15 min)"
		if not GameState.tap_running and GameState.mosquito_level > 0:
			interaction_prompt.text = "E - Cleanup / mosquitoes"
	elif target == plant:
		interaction_prompt.text = "E - Dry plant area (10 min)"
		if GameState.mosquito_level > 0:
			interaction_prompt.text = "E - Cleanup / mosquitoes"
	elif target == bookshelf:
		interaction_prompt.text = "E - Organize books (20 min)"
	else:
		interaction_prompt.text = "E - Make bed (5 min)" if GameState.needs_cleanup("bed") else "E - Rest"
	interaction_prompt.size = interaction_prompt.get_combined_minimum_size()
	var point: Vector2 = target.get_global_transform_with_canvas().origin
	# Stay above the fixture instead of jumping to a distant side to avoid Judy.
	var pos: Vector2 = point + Vector2(-interaction_prompt.size.x * 0.5, -28 - interaction_prompt.size.y)
	var top_margin := 42.0
	if target == tiptop:
		var thought: Label = tiptop.monologue_label if tiptop.monologue_label.visible else tiptop.action_label
		if thought.visible:
			# Stack the interaction cue above the bubble, in the prompt's canvas.
			# Include the HUD scale so the gap remains correct after resizing.
			var to_prompt: Transform2D = interaction_prompt.get_canvas_transform().affine_inverse() * thought.get_global_transform_with_canvas()
			var bubble_rect: Rect2 = to_prompt * Rect2(Vector2.ZERO, thought.size)
			pos = Vector2(bubble_rect.get_center().x - interaction_prompt.size.x * 0.5, bubble_rect.position.y - interaction_prompt.size.y - 3)
			top_margin = 4.0
	pos = pos.clamp(Vector2(4, top_margin), Vector2(380, 232) - interaction_prompt.size)
	if interaction_prompt.visible and prompt_target == target:
		interaction_prompt.position = interaction_prompt.position.lerp(pos, 1.0 - exp(-20.0 * get_process_delta_time()))
	else:
		interaction_prompt.position = pos
	prompt_target = target
	interaction_prompt.show()


func _interaction_position(target: Node2D) -> Vector2:
	if target == fridge:
		return fridge.to_global(Vector2(0, 7))
	if target == bookshelf:
		# Include the scattered books on the floor, not just the shelf origin.
		var local := bookshelf.to_local(global_position)
		return bookshelf.to_global(local.clamp(Vector2(-18, 0), Vector2(18, 12)))
	if target in [bed, plant]:
		return target.global_position
	# Keep interaction centers unchanged when scene origins move to the floor.
	var height := (8.0 if target == desk else (7.0 if target == tiptop else 6.0)) * target.scale.y
	return target.global_position - Vector2(0, height)


func _nearest_interaction() -> Node2D:
	if GameState.day_ended or GameState.game_finished or GameState.notification_active:
		return null
	if GameState.needs_cleanup("bookshelf") and global_position.distance_to(_interaction_position(bookshelf)) <= 18.0:
		return bookshelf
	var nearest: Node2D = null
	var nearest_distance := INF
	for target in [desk, tiptop, sink, bed, plant, bookshelf, fridge]:
		if target == desk:
			if not desk.get("player_nearby"):
				continue
		elif target == tiptop:
			if global_position.distance_to(_interaction_position(tiptop)) > INTERACTION_DISTANCE:
				continue
		elif target == bed:
			if global_position.distance_to(bed.global_position) > INTERACTION_DISTANCE:
				continue
		elif target == fridge:
			if global_position.y < fridge.global_position.y or global_position.distance_to(_interaction_position(fridge)) > 20:
				continue
		else:
			var chore := "sink" if target == sink else ("plant" if target == plant else "bookshelf")
			if (not GameState.needs_cleanup(chore) and not (chore in ["sink", "plant"] and GameState.mosquito_level > 0)) or global_position.distance_to(_interaction_position(target)) > INTERACTION_DISTANCE:
				continue
		var distance: float = global_position.distance_squared_to(_interaction_position(target))
		if distance < nearest_distance:
			nearest = target
			nearest_distance = distance
	return nearest


func _unhandled_input(event: InputEvent) -> void:
	if animation_busy:
		return
	if not event.is_action_pressed("interact") or event.is_echo():
		return
	var target := _nearest_interaction()
	if target == null:
		return
	get_viewport().set_input_as_handled()
	if target == desk:
		get_node("../HUD").research_choices()
	elif target == tiptop:
		get_node("../HUD").tiptop_interaction()
	elif target == fridge:
		get_node("../HUD").household_choices("fridge")
	elif target == bed:
		if GameState.needs_cleanup("bed"):
			_clean_animation("bed")
		else:
			GameState.end_day()
	elif target == plant or target == bookshelf:
		if target == plant and GameState.mosquito_level > 0:
			get_node("../HUD").household_choices("plant")
		else:
			_clean_animation("plant" if target == plant else "bookshelf")
	else:
		if GameState.tap_running:
			GameState.turn_off_tap()
		else:
			get_node("../HUD").household_choices("sink")


func _physics_process(_delta: float) -> void:
	if animation_busy:
		interaction_prompt.hide()
		return
	var input := Vector2.ZERO
	input.x = Input.get_axis("move_left", "move_right")
	input.y = Input.get_axis("move_up", "move_down")

	if input.length() > 1.0:
		input = input.normalized()

	velocity = input * SPEED
	move_and_slide()
	if input != Vector2.ZERO:
		var direction := "down"
		if absf(input.x) > absf(input.y):
			direction = "right" if input.x > 0 else "left"
		else:
			direction = "down" if input.y > 0 else "up"
		visual.play("walk_" + direction)
	else:
		visual.pause()
		visual.frame = 0


func _process(_delta: float) -> void:
	if animation_busy or get_tree().paused:
		interaction_prompt.hide()
		return
	_update_interaction_prompt(_nearest_interaction())


func personal_activity(activity: String) -> void:
	if animation_busy or get_tree().paused or not GameState.PERSONAL_ACTIVITIES.has(activity):
		return
	var duration: int = GameState.PERSONAL_ACTIVITIES[activity][0]
	if GameState.DAY_END - GameState.time_minutes - GameState.clock_fraction - GameState.world_accumulator < duration:
		GameState.action_feedback.emit("Not enough time before 8:00 PM for that activity.")
		return
	animation_busy = true
	velocity = Vector2.ZERO
	interaction_prompt.hide()
	var table: Node2D = get_node("../CoffeeTable")
	var collision: CollisionShape2D = table.get_node("CollisionShape2D")
	var footprint := collision.shape as RectangleShape2D
	var seat: Vector2 = table.to_global(collision.position + Vector2(0, footprint.size.y * 0.5)) + Vector2(0, 9)
	var arrived: bool = await _walk_to_activity_seat(seat)
	if not arrived or not GameState.start_personal_activity(activity):
		animation_busy = false
		GameState.action_feedback.emit("Couldn't start the activity. No activity time or reward applied.")
		return
	# Reuse the research pose's cropped torso and bent knees, facing the table.
	var seated := Node2D.new()
	add_child(seated)
	var source: AtlasTexture = visual.sprite_frames.get_frame_texture("walk_up", 0)
	var crop := AtlasTexture.new()
	crop.atlas = source.atlas
	crop.region = Rect2(source.region.position, Vector2(48, 34))
	var torso := Sprite2D.new()
	torso.texture = crop
	torso.texture_filter = CanvasItem.TEXTURE_FILTER_NEAREST
	torso.scale = Vector2(0.5, 0.5)
	torso.position = Vector2(0, -8.5)
	seated.add_child(torso)
	var knees := Polygon2D.new()
	knees.polygon = PackedVector2Array([Vector2(-4, -2), Vector2(4, -2), Vector2(5, 2), Vector2(2, 4), Vector2(-2, 4), Vector2(-5, 2)])
	knees.color = Color("34313d")
	seated.add_child(knees)
	seated.modulate.a = 0.0
	var sit := _pose_tween()
	sit.tween_property(seated, "modulate:a", 1.0, 0.15)
	visual.hide()
	get_node("../HUD").research_strip.show()
	var motion := 0.0
	while not GameState.personal_activity.is_empty():
		await get_tree().process_frame
		if not get_tree().paused:
			motion += get_process_delta_time()
			torso.rotation = sin(motion * 1.6) * 0.025
	get_node("../HUD").research_strip.hide()
	seated.queue_free()
	visual.show()
	visual.animation = "walk_up"
	visual.frame = 0
	visual.pause()
	animation_busy = false


func _walk_to_activity_seat(point: Vector2) -> bool:
	await get_tree().physics_frame
	# Use the same compact grid and footprint clearance as TipTop, without
	# changing his active route. Exact connectors handle the shelf's narrow strip.
	var shelf_front: Vector2 = tiptop._bookshelf_front()
	var shelf_exit: Vector2 = tiptop._bookshelf_exit()
	if absf(global_position.y - shelf_front.y) < 3 and global_position.x < shelf_exit.x and test_move(global_transform, point - global_position):
		await _walk_for_animation(shelf_exit)
		if global_position.distance_to(shelf_exit) > 2:
			return false
	var grid := AStarGrid2D.new()
	grid.region = Rect2i(5, 3, 31, 22)
	grid.cell_size = Vector2(8, 8)
	grid.diagonal_mode = AStarGrid2D.DIAGONAL_MODE_ONLY_IF_NO_OBSTACLES
	grid.update()
	var shape := RectangleShape2D.new()
	shape.size = Vector2(10, 6)
	var query := PhysicsShapeQueryParameters2D.new()
	query.shape = shape
	query.collision_mask = collision_mask
	query.exclude = [get_rid(), tiptop.get_rid()]
	var start := Vector2i.ZERO
	var finish := Vector2i.ZERO
	var start_distance := INF
	var finish_distance := INF
	for y in range(3, 25):
		for x in range(5, 36):
			var cell := Vector2i(x, y)
			var location := Vector2(x, y) * 8
			query.transform = Transform2D(0, location + Vector2(0, -2))
			var blocked: bool = not Geometry2D.is_point_in_polygon(location, PackedVector2Array(tiptop.APARTMENT_ART.ROOM_EDGE)) or not get_world_2d().direct_space_state.intersect_shape(query, 1).is_empty()
			grid.set_point_solid(cell, blocked)
			if blocked:
				continue
			if location.distance_squared_to(global_position) < start_distance and not test_move(global_transform, location - global_position):
				start = cell
				start_distance = location.distance_squared_to(global_position)
			var from_cell := global_transform
			from_cell.origin = location
			if location.distance_squared_to(point) < finish_distance and not test_move(from_cell, point - location):
				finish = cell
				finish_distance = location.distance_squared_to(point)
	if start_distance == INF or finish_distance == INF:
		return false
	var route := grid.get_point_path(start, finish)
	if route.is_empty():
		return false
	route.append(point)
	var elapsed := 0.0
	var stalled := 0.0
	while global_position.distance_to(point) > 1.0 and elapsed < 12.0:
		await get_tree().physics_frame
		if get_tree().paused or GameState.day_ended or GameState.game_finished or GameState.notification_active:
			velocity = Vector2.ZERO
			visual.pause()
			return false
		var delta := get_physics_process_delta_time()
		elapsed += delta
		var aim := global_position
		for index in range(route.size() - 1, -1, -1):
			if not test_move(global_transform, route[index] - global_position):
				aim = route[index]
				break
		velocity = global_position.direction_to(aim) * minf(SPEED, global_position.distance_to(aim) / delta)
		if absf(velocity.x) > absf(velocity.y):
			visual.play("walk_right" if velocity.x > 0 else "walk_left")
		else:
			visual.play("walk_down" if velocity.y > 0 else "walk_up")
		var before := global_position
		move_and_slide()
		stalled = stalled + delta if global_position.distance_to(before) < 0.02 else 0.0
		if stalled > 1.5:
			break
	velocity = Vector2.ZERO
	visual.pause()
	return global_position.distance_to(point) <= 1.0


func _walk_for_animation(point: Vector2) -> void:
	var elapsed := 0.0
	while global_position.distance_to(point) > 1.0 and elapsed < 1.2:
		await get_tree().physics_frame
		var delta := get_physics_process_delta_time()
		elapsed += delta
		velocity = global_position.direction_to(point) * minf(SPEED, global_position.distance_to(point) / delta)
		if absf(velocity.x) > absf(velocity.y):
			visual.play("walk_right" if velocity.x > 0 else "walk_left")
		else:
			visual.play("walk_down" if velocity.y > 0 else "walk_up")
		move_and_slide()
	velocity = Vector2.ZERO
	visual.pause()
	visual.frame = 0


func _pose_tween() -> Tween:
	return create_tween().set_pause_mode(Tween.TWEEN_PAUSE_PROCESS).set_trans(Tween.TRANS_SINE).set_ease(Tween.EASE_IN_OUT)


func _research_animation(fast_forward := false) -> void:
	if animation_busy or GameState.work_sessions_remaining <= 0 or GameState.day_ended or GameState.game_finished:
		return
	if not GameState.research_available():
		if GameState.has_research_time() and GameState.mood_allows_research() and int(GameState.chore_mess["bookshelf"]) >= 2:
			get_node("../HUD").household_choices("bookshelf")
			return
		GameState.action_feedback.emit(GameState.research_block_reason())
		return
	animation_busy = true
	GameState.household_busy = true
	interaction_prompt.hide()
	var chair: Node2D = get_node("../Chair")
	# Enter from the side of the seat, never through its rear upright.
	var seat_side := 20 if global_position.x >= chair.global_position.x else -20
	var standing := chair.global_position + Vector2(seat_side, 6)
	if test_move(global_transform, standing - global_position):
		var side := chair.global_position.x + (24 if global_position.x >= chair.global_position.x else -24)
		await _walk_for_animation(Vector2(side, global_position.y))
		await _walk_for_animation(Vector2(side, standing.y))
	await _walk_for_animation(standing)
	if global_position.distance_to(standing) > 2.0:
		animation_busy = false
		GameState.household_busy = false
		return
	visual.animation = "walk_up"
	visual.frame = 0
	var seat := chair.global_position + Vector2(0, -6) * chair.scale - global_position
	var sit := _pose_tween().set_parallel()
	sit.tween_property(visual, "scale", Vector2(0.5, 0.36), 0.18)
	sit.tween_property(visual, "position", seat + Vector2(0, -8), 0.18)
	await sit.finished
	# Crop away the straight walking legs; add bent knees below the torso.
	var seated := Node2D.new()
	seated.position = seat
	add_child(seated)
	var source: AtlasTexture = visual.sprite_frames.get_frame_texture("walk_up", 0)
	var torso_texture := AtlasTexture.new()
	torso_texture.atlas = source.atlas
	torso_texture.region = Rect2(source.region.position, Vector2(48, 34))
	var torso := Sprite2D.new()
	torso.texture = torso_texture
	torso.texture_filter = CanvasItem.TEXTURE_FILTER_NEAREST
	torso.scale = Vector2(0.5, 0.5)
	torso.position = Vector2(0, -8.5)
	seated.add_child(torso)
	var knees := Polygon2D.new()
	knees.polygon = PackedVector2Array([Vector2(-4, -2), Vector2(4, -2), Vector2(5, 2), Vector2(2, 4), Vector2(-2, 4), Vector2(-5, 2)])
	knees.color = Color("34313d")
	seated.add_child(knees)
	visual.hide()
	research_fast_forward = fast_forward
	GameState.research_playback_rate = 6.0 if fast_forward else 1.0
	GameState.household_busy = false
	if not GameState.begin_research():
		seated.queue_free()
		visual.show()
		visual.position = Vector2(0, -10)
		visual.scale = Vector2(0.5, 0.5)
		animation_busy = false
		GameState.research_playback_rate = 1.0
		return
	get_node("../HUD").set_research_controls(true)
	var motion_time := 0.0
	var interruptions := 0
	var swat_left := 0.0
	while GameState.research_elapsed < GameState.research_duration:
		await get_tree().process_frame
		if get_tree().paused:
			continue
		var delta := get_process_delta_time()
		GameState.research_playback_rate = 6.0 if research_fast_forward else 1.0
		motion_time += delta * minf(2.0, GameState.research_playback_rate)
		if GameState.research_interruptions != interruptions:
			interruptions = GameState.research_interruptions
			swat_left = 0.35
		swat_left = maxf(0.0, swat_left - delta)
		torso.position.y = -8.5 + sin(motion_time * 3.0) * 0.3 + sin(motion_time * 0.7) * 0.2
		torso.rotation = sin(motion_time * 1.1) * 0.025 if swat_left == 0 else sin(swat_left * 30) * 0.12
	get_node("../HUD").set_research_controls(false)
	GameState.household_busy = true
	seated.queue_free()
	visual.show()
	var stand := _pose_tween().set_parallel()
	stand.tween_property(visual, "scale", Vector2(0.5, 0.5), 0.18)
	stand.tween_property(visual, "position", Vector2(0, -10), 0.18)
	await stand.finished
	animation_busy = false
	GameState.household_busy = false
	# Apply the existing session once, after restoring the pose and before dialogue.
	GameState.complete_research()


func _clean_animation(chore: String) -> void:
	if animation_busy or not GameState.needs_cleanup(chore):
		return
	animation_busy = true
	GameState.household_busy = true
	velocity = Vector2.ZERO
	interaction_prompt.hide()
	GameState.action_feedback.emit("Judy: Right. Let's sort this out.")
	var tidy := _pose_tween()
	tidy.tween_property(visual, "rotation", -0.08, 0.15)
	tidy.tween_property(visual, "rotation", 0.08, 0.15)
	tidy.tween_property(visual, "rotation", 0.0, 0.15)
	await tidy.finished
	GameState.manual_clean(chore)
	GameState.household_busy = false
	animation_busy = false


func organize_for_research() -> void:
	if animation_busy:
		return
	animation_busy = true
	GameState.household_busy = true
	# Walk through the open central aisle to the shelf's accessible right side.
	var standing := bookshelf.global_position + Vector2(24, 4)
	var aisle_x := bookshelf.global_position.x + 48.0
	await _walk_for_animation(Vector2(aisle_x, global_position.y))
	await _walk_for_animation(Vector2(aisle_x, standing.y))
	await _walk_for_animation(standing)
	GameState.household_busy = false
	animation_busy = false
	if global_position.distance_to(bookshelf.global_position) <= INTERACTION_DISTANCE + 4:
		_clean_animation("bookshelf")
	else:
		GameState.action_feedback.emit("Approach the bookshelf and press E to organize it (20 min).")


func swat_animation() -> void:
	if animation_busy or GameState.mosquito_level == 0:
		return
	animation_busy = true
	GameState.household_busy = true
	var swat := _pose_tween()
	swat.tween_property(visual, "rotation", 0.12, 0.15)
	swat.tween_property(visual, "rotation", 0.0, 0.15)
	await swat.finished
	GameState.swat_mosquitoes(true)
	GameState.household_busy = false
	animation_busy = false


func play_sleep_animation() -> void:
	if animation_busy:
		return
	animation_busy = true
	interaction_prompt.hide()
	var side := 25 if global_position.x >= bed.global_position.x else -25
	var standing := bed.global_position + Vector2(side, 6)
	await _walk_for_animation(Vector2(standing.x, global_position.y))
	await _walk_for_animation(standing)
	if global_position.distance_to(standing) > 2.0:
		await _walk_for_animation(Vector2(global_position.x, standing.y))
		await _walk_for_animation(standing)
	visual.animation = "walk_down"
	visual.frame = 0
	var tuck_in := _pose_tween().set_parallel()
	tuck_in.tween_property(visual, "position", bed.global_position + Vector2(0, -22) * bed.scale - global_position, 0.3)
	tuck_in.tween_property(visual, "scale", Vector2(0.5, 0.4), 0.3)
	await tuck_in.finished
	sleep_blanket = ColorRect.new()
	sleep_blanket.position = bed.global_position + Vector2(-13, -24) * bed.scale - global_position
	sleep_blanket.size = Vector2(26, 20) * bed.scale
	sleep_blanket.color = Color("657a55")
	sleep_blanket.mouse_filter = Control.MOUSE_FILTER_IGNORE
	add_child(sleep_blanket)
	await get_tree().create_timer(0.25).timeout


func wake_from_bed() -> void:
	if is_instance_valid(sleep_blanket):
		sleep_blanket.queue_free()
	visual.position = Vector2(0, -10)
	visual.scale = Vector2(0.5, 0.5)
	visual.animation = "walk_down"
	visual.frame = 0
	velocity = Vector2.ZERO
	animation_busy = false
