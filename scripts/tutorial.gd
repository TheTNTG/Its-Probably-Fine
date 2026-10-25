extends Control

# A nonblocking guide owned by the existing HUD, never a second dialogue system.
var hud: CanvasLayer
var panel: PanelContainer
var heading: Label
var explanation: Label
var skip: Button
var pending: Array[Dictionary] = []
var current: Dictionary = {}
var reviewing := false
var outline := Rect2()
var pulse := 0.0
var placed_step := ""
const AMBER := Color("e6b369")
const GUIDED_STEPS := ["guide_move", "guide_clock", "guide_desk", "guide_robot", "guide_needs", "guide_target", "guide_sleep", "guide_pause"]
const WORLD_BOUNDS := {
	"Desk": Rect2(-17, -26, 34, 28), "Bed": Rect2(-17, -47, 34, 49),
	"Sink": Rect2(-13, -39, 26, 41), "Bookshelf": Rect2(-18, -40, 36, 42),
	"PlantPot": Rect2(-9, -25, 18, 27), "Fridge": Rect2(-12, -34, 26, 36),
	"CoffeeTable": Rect2(-15, -18, 31, 23)}


func _ready() -> void:
	hud = get_parent() as CanvasLayer
	process_priority = 3
	mouse_filter = Control.MOUSE_FILTER_IGNORE
	texture_filter = CanvasItem.TEXTURE_FILTER_LINEAR
	panel = PanelContainer.new()
	var style := StyleBoxFlat.new()
	style.bg_color = Color("23242bf5")
	style.border_color = AMBER
	style.set_border_width_all(1)
	style.set_corner_radius_all(4)
	style.set_content_margin_all(6)
	panel.add_theme_stylebox_override("panel", style)
	panel.custom_minimum_size.x = 218
	add_child(panel)
	var box := VBoxContainer.new()
	box.add_theme_constant_override("separation", 3)
	panel.add_child(box)
	heading = Label.new()
	preload("res://scripts/typography.gd").accent(heading)
	heading.add_theme_font_size_override("font_size", 9)
	heading.add_theme_color_override("font_color", AMBER)
	box.add_child(heading)
	explanation = Label.new()
	explanation.custom_minimum_size.x = 206
	explanation.autowrap_mode = TextServer.AUTOWRAP_WORD_SMART
	explanation.add_theme_font_size_override("font_size", 8)
	explanation.add_theme_color_override("font_color", Color("f5e6cd"))
	box.add_child(explanation)
	var buttons := HBoxContainer.new()
	buttons.add_theme_constant_override("separation", 6)
	box.add_child(buttons)
	var next := Button.new()
	next.text = "E / Enter · Got it"
	next.add_theme_font_size_override("font_size", 8)
	next.pressed.connect(_complete)
	buttons.add_child(next)
	skip = Button.new()
	skip.text = "Skip Tutorial"
	skip.add_theme_font_size_override("font_size", 8)
	skip.pressed.connect(_skip)
	buttons.add_child(skip)
	if hud.get("tutorial_entry"):
		var exit := Button.new()
		exit.text = "Exit Tutorial"
		exit.add_theme_font_size_override("font_size", 7)
		exit.pressed.connect(func(): hud.call("_restart_from_pause", false))
		box.add_child(exit)
	panel.hide()
	GameState.action_feedback.connect(_feedback)


func _safe() -> bool:
	return not hud.call("hud_navigation_active") and not get_tree().paused and not GameState.research_active and GameState.personal_activity.is_empty() and not GameState.household_busy and not GameState.repair_in_progress and not GameState.day_ended and not GameState.game_finished and not GameState.notification_active and not hud.get("transitioning") and not hud.get("sleep_dialogue_pending") and not hud.get_node("../Player").get("animation_busy") and not hud.get("dialogue_overlay").visible and not hud.get("repair_panel").visible and not hud.get("loop_panel").visible and not hud.call("_household_open") and not hud.call("_pause_open") and hud.get("dialogue_lines").is_empty() and hud.get("deferred_story_events").is_empty() and hud.get("pending_feedback").is_empty() and int(hud.get("morning_pending_day")) == 0 and float(hud.get("system_left")) <= 0 and hud.get("system_messages").is_empty()


func _offer(id: String, text: String, target: String, guided: bool = false) -> void:
	if GameState.tutorial_seen.has(id) or current.get("id", "") == id:
		return
	for item in pending:
		if item["id"] == id:
			return
	pending.append({"id": id, "text": text, "target": target, "guided": guided})


func _near(node_name: String) -> bool:
	var target: Node2D = hud.get_node("../" + node_name)
	var player: Node2D = hud.get_node("../Player")
	return player.global_position.distance_to(target.global_position) < 55


func _detect() -> void:
	# Essential explanations survive Skip Tutorial and wait through active tasks.
	if GameState.tap_running:
		_offer("water", "The running tap halves research gains and makes sessions longer. Turn it off at the sink; repair the sink routine to prevent repeats.", "Sink")
	if int(GameState.chore_mess["bookshelf"]) >= 2:
		_offer("books", "Scattered books block research. Press E near the shelf or fallen books to organize them for 20 minutes. Cleanup leaves the routine faulty.", "Bookshelf")
	if int(GameState.chore_mess["plant"]) > 0:
		_offer("plant", "Repeated watering leaves wet soil and puddles. Standing water attracts mosquitoes, which interrupt work. Dry the area and repair the plant routine to prevent repeats.", "PlantPot")
	if int(GameState.chore_mess["bed"]) >= 2:
		_offer("bed_mess", "TipTop has made the bed messier. Make it before resting, or let its repaired routine tidy it.", "Bed")
	if GameState.mood < 45 and _near("Desk"):
		_offer("mood", "Research normally needs 45 Mood. Meals and leisure restore it and reset the work streak. Day 3's Mood exception never bypasses the more-than-20 Fullness requirement.", "CoffeeTable")
	if GameState.hunger < 60:
		_offer("hunger", "Below 60 Fullness, research gains fall. At 20 or less, you can't start work. A 30-minute meal restores 40 Fullness and 10 Mood, and counts as a break.", "Fridge")
	if GameState.repairs.values().has(true):
		_offer("repair", "A repaired routine stays corrected and earns research progress. Existing mess may still need cleanup. Each routine is repaired independently.", "TipTop")
	if GameState.research_progress >= GameState.GOOD_ENDING_RESEARCH_THRESHOLD:
		_offer("target", "You've reached the 75% showcase research requirement! Other choices and TipTop's repair state still matter. The showcase is Day 3 at 8 PM.", "research")
	if GameState.tutorial_skipped and not reviewing:
		return
	var anywhere := reviewing
	_offer("guide_move", "Move with WASD or arrows; approach objects for E prompts. TipTop waits until you read all eight tips or choose Skip Tutorial. Essential warnings stay enabled.", "Player", true)
	_offer("guide_clock", "The clock runs while you explore. Showcase: Day 3, 8 PM. This bar counts 27 playable hours, excluding nights. Hover/focus icons for details; click to pin.", "deadline", true)
	if anywhere or _near("Desk"):
		_offer("guide_desk", "Use E at the desk for up to four sessions daily. Starting work needs more than 20 Fullness. Watch, 6x and Skip process the same world time and consequences.", "Desk", true)
	if anywhere or _near("TipTop"):
		_offer("guide_robot", "TipTop means well. Faulty chores make real messes. His robot icon shows the repair checklist; E near him opens repairs. Cleaning alone doesn't correct a routine.", "repairs", true)
	if anywhere or _near("Fridge") or _near("CoffeeTable") or GameState.hunger < 75:
		_offer("guide_needs", "Fullness shifts from sage to brick as it falls. Meals restore Fullness and Mood; meals and leisure reset your work streak. Click the heart, or Tab then arrows, for details.", "needs", true)
	if anywhere or _near("Desk"):
		_offer("guide_target", "Aim for 75%% research. On %s, a standard session costs %d game minutes. A running tap adds time and cuts gains; repairs can also earn progress." % [GameState.profile()["name"], GameState.profile()["research_minutes"]], "research", true)
	if anywhere or _near("Bed"):
		_offer("guide_sleep", "Make the bed, then E to rest and end the day. Sleeping starts the next day; bedtime fullness affects tomorrow's Mood. Meals and breaks need planning too.", "Bed", true)
	if anywhere or GameState.tutorial_seen.has("guide_target"):
		_offer("guide_pause", "Esc opens Pause: save when free, or review the guide. Active tasks have Watch, 6x, Skip and Eject. Eject keeps spent time and gives no reward.", "controls", true)


func _feedback(message: String) -> void:
	var lower := message.to_lower()
	if "not enough time" in lower or ("full repair needs" in lower):
		_offer("time", "A full activity must fit before 8 PM, including tap penalties for research. Check remaining time or choose a shorter activity. A rejected start spends no session or reward.", "clock")


func warn_before_sleep() -> bool:
	var id := "sleep_hungry_%d" % GameState.day
	if GameState.hunger >= 70 or GameState.tutorial_seen.has(id):
		return false
	# The player can dismiss this tip, eat, or press E at the bed again.
	_offer(id, "Sleeping below 70 fullness lowers tomorrow's starting Mood; very low fullness is worse. Consider eating first. Dismiss this tip, then E at the bed again if you're ready.", "Fridge")
	return true


func review() -> void:
	for key in GameState.tutorial_seen.keys():
		if str(key).begins_with("guide_"):
			GameState.tutorial_seen.erase(key)
	reviewing = true
	current.clear()
	panel.hide()


func _complete() -> void:
	if current.is_empty():
		return
	GameState.tutorial_seen[current["id"]] = true
	if not GameState.tutorial_finished:
		var finished := true
		for id in GUIDED_STEPS:
			if not GameState.tutorial_seen.has(id):
				finished = false
		GameState.tutorial_finished = finished
		if finished:
			SaveStore.remember_tutorial(true)
			SaveStore.request_autosave("tutorial_completed")
	current.clear()
	panel.hide()
	get_viewport().gui_release_focus()
	queue_redraw()


func _skip() -> void:
	SaveStore.remember_tutorial(false)
	GameState.tutorial_skipped = true
	GameState.tutorial_finished = true
	SaveStore.request_autosave("tutorial_skipped")
	reviewing = false
	for index in range(pending.size() - 1, -1, -1):
		if pending[index]["guided"]:
			pending.remove_at(index)
	skip.hide()
	if current.get("guided", false):
		_complete()


func handle_input(event: InputEvent) -> bool:
	if not panel.visible or not _safe():
		return false
	if event is InputEventKey and (event.is_action("interact") or event.keycode in [KEY_ENTER, KEY_KP_ENTER]):
		var target: String = current.get("target", "")
		var interact_here: bool = event.is_action("interact") and target in WORLD_BOUNDS and _near(target)
		if event.pressed and not event.echo:
			_complete()
		# Let the same E press reach a nearby highlighted fixture's interaction.
		return not interact_here
	return false


func _bounds(target: String) -> Rect2:
	var node: CanvasItem
	var local: Rect2
	match target:
		"clock":
			node = hud.get("time_bar").get_parent()
		"deadline":
			node = hud.get("deadline_bar").get_parent()
		"repairs":
			node = hud.get("detail_buttons")["repairs"]
		"needs":
			node = hud.get("hunger_bar").get_parent()
		"research":
			node = hud.get("overview_bar").get_parent()
		"controls":
			# Reference-canvas coordinates of the existing controls card.
			return Rect2(5, 242, 54, 28).grow(2)
		_:
			var world: Node2D = hud.get_node("../" + target)
			if target in ["Player", "TipTop"]:
				node = world.get_node("Visual")
				var sprite := node as AnimatedSprite2D
				var frame_size := sprite.sprite_frames.get_frame_texture(sprite.animation, sprite.frame).get_size()
				local = Rect2(sprite.offset - frame_size * 0.5 if sprite.centered else sprite.offset, frame_size)
			else:
				node = world.get_node("Visual")
				# Local drawing extents, transformed with the actual furniture node.
				local = WORLD_BOUNDS.get(target, Rect2(-12, -24, 24, 26))
	if node is Control:
		local = Rect2(Vector2.ZERO, (node as Control).size)
	var to_ui: Transform2D = get_global_transform_with_canvas().affine_inverse() * node.get_global_transform_with_canvas()
	return (to_ui * local).grow(2)


func _process(delta: float) -> void:
	_detect()
	panel.visible = _safe() and not current.is_empty()
	if not _safe():
		outline = Rect2()
		queue_redraw()
		return
	if current.is_empty() and not pending.is_empty():
		current = pending.pop_front()
		heading.text = "Quick tip" if not current["guided"] else "Getting settled"
		if current["guided"]:
			var read_count := 0
			for id in GUIDED_STEPS:
				if GameState.tutorial_seen.has(id):
					read_count += 1
			heading.text += " · %d / 8" % (read_count + 1)
		explanation.text = current["text"]
		skip.visible = not GameState.tutorial_skipped or reviewing
		panel.reset_size()
		panel.show()
	if current.is_empty():
		outline = Rect2()
		queue_redraw()
		return
	outline = _bounds(str(current["target"]))
	_place_instruction()
	pulse += delta
	queue_redraw()


func _place_instruction() -> void:
	var judy := _bounds("Player").grow(4)
	var robot := _bounds("TipTop").grow(4)
	var occupied := Rect2(panel.position, panel.size).grow(4)
	var id: String = current["id"]
	if placed_step == id and not occupied.intersects(outline) and not occupied.intersects(judy) and not occupied.intersects(robot):
		return
	placed_step = id
	var center := outline.get_center()
	var candidates := [Vector2(center.x - panel.size.x * 0.5, outline.end.y + 12), Vector2(center.x - panel.size.x * 0.5, outline.position.y - panel.size.y - 12), Vector2(outline.end.x + 12, center.y - panel.size.y * 0.5), Vector2(outline.position.x - panel.size.x - 12, center.y - panel.size.y * 0.5), Vector2(72, 281 - panel.size.y), Vector2(8, 42), Vector2(104, 42)]
	var best := INF
	for candidate in candidates:
		var point: Vector2 = candidate.clamp(Vector2(4, 42), Vector2(328, 282) - panel.size)
		var rect := Rect2(point, panel.size).grow(4)
		var score := rect.get_center().distance_squared_to(center)
		if rect.intersects(outline):
			score += 1000000
		if rect.intersects(judy) or rect.intersects(robot):
			score += 100000
		if score < best:
			best = score
			panel.position = point.round()


func _draw() -> void:
	if not panel.visible or not outline.has_area():
		return
	var transform_to_ui := get_global_transform_with_canvas().affine_inverse()
	var screen: Rect2 = transform_to_ui * get_viewport_rect()
	var hole := outline.intersection(screen)
	var dim := Color(0.035, 0.03, 0.045, 0.60)
	if not hole.has_area():
		draw_rect(screen, dim)
		return
	# Four disjoint regions leave a real, undimmed cutout around the target.
	draw_rect(Rect2(screen.position, Vector2(screen.size.x, maxf(0, hole.position.y - screen.position.y))), dim)
	draw_rect(Rect2(Vector2(screen.position.x, hole.end.y), Vector2(screen.size.x, maxf(0, screen.end.y - hole.end.y))), dim)
	draw_rect(Rect2(Vector2(screen.position.x, hole.position.y), Vector2(maxf(0, hole.position.x - screen.position.x), hole.size.y)), dim)
	draw_rect(Rect2(Vector2(hole.end.x, hole.position.y), Vector2(maxf(0, screen.end.x - hole.end.x), hole.size.y)), dim)
	var width := 4.0 / maxf(0.01, get_global_transform_with_canvas().get_scale().x)
	var color := AMBER
	color.a = 0.92 + sin(pulse * 1.5) * 0.05
	if str(current["target"]) in ["clock", "deadline", "research", "repairs", "needs", "controls"]:
		var rounded := PackedVector2Array()
		var radius := minf(4, minf(outline.size.x, outline.size.y) * 0.25)
		var corners := [outline.position + Vector2(radius, radius), Vector2(outline.end.x - radius, outline.position.y + radius), outline.end - Vector2(radius, radius), Vector2(outline.position.x + radius, outline.end.y - radius)]
		for corner in range(4):
			for segment in range(6):
				var angle := PI + corner * PI * 0.5 + segment * PI * 0.1
				rounded.append(corners[corner] + Vector2.from_angle(angle) * radius)
		rounded.append(rounded[0])
		draw_polyline(rounded, color, width, true)
	else:
		draw_rect(outline, color, false, width)
	var instruction := Rect2(panel.position, panel.size)
	var start := outline.get_center().clamp(instruction.position, instruction.end)
	var end := instruction.get_center().clamp(outline.position, outline.end)
	if start.distance_to(end) > 5:
		var direction := start.direction_to(end)
		draw_line(start, end, color, width * 0.6, true)
		draw_colored_polygon(PackedVector2Array([end, end - direction.rotated(0.5) * 5, end - direction.rotated(-0.5) * 5]), color)
