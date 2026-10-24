extends Node

# Presentation only. Audio has its own RNG and real-time cadence, never the
# simulation's random sequence, clock, task selection or completion logic.
const LAYER = preload("res://scripts/audio_layer.gd")
const APARTMENT_THEME_PATH := "res://assets/audio/music/chilllofir-loop.ogg"
const ROOT := "res://assets/audio/"
const FILES := {
	"room": "ambience/room_tone.mp3", "fridge": "ambience/fridge_hum.wav",
	"tap": "ambience/tap.mp3", "servo": "ambience/servo.mp3", "mosquito": "ambience/mosquito.mp3",
	"typing": "foley/typing.mp3", "paper": "foley/paper.mp3", "desk": "foley/desk.ogg",
	"fridge_open": "foley/fridge_open.mp3", "fridge_close": "foley/fridge_close.mp3",
	"cutlery": "foley/cutlery.mp3", "eating": "foley/eating.mp3", "click": "foley/click.mp3", "cube": "foley/cube.mp3",
	"cloth": "foley/cloth.mp3", "tools": "foley/tools.mp3", "wipe": "foley/wipe.mp3",
	"book_fall": "foley/book_fall.mp3", "water_plant": "foley/water_plant.mp3",
	"drip": "foley/drip.mp3", "swat": "foley/swat.ogg",
	"step_0": "foley/step_wood_0.ogg", "step_1": "foley/step_wood_1.ogg", "step_2": "foley/step_wood_2.ogg"
}
# Source, quiet gain, excerpt duration, offset. No synthesized reward tones.
const CUES := {
	"paper": ["paper", -20.0, 1.3, 0.0], "desk": ["desk", -21.0, 0.35, 0.0],
	"fridge_open": ["fridge_open", -20.0, 3.0, 0.0], "fridge_close": ["fridge_close", -20.0, 1.2, 0.0],
	"meal": ["cutlery", -18.0, 1.7, 0.0], "eating": ["eating", -23.0, 3.8, 0.0], "phone": ["click", -24.0, 0.4, 0.0],
	"cube": ["cube", -25.0, 1.35, 0.0], "bedding": ["cloth", -23.0, 1.7, 0.0],
	"repair": ["tools", -18.0, 2.5, 0.0], "clean": ["wipe", -19.0, 2.0, 0.5],
	"books": ["paper", -20.0, 1.3, 0.0], "book_fall": ["book_fall", -20.0, 3.8, 0.0],
	"watering": ["water_plant", -19.0, 3.0, 0.0], "drip": ["drip", -23.0, 2.0, 0.0],
	"swat": ["swat", -18.0, 0.4, 0.0], "click": ["click", -23.0, 0.4, 0.0],
	"menu": ["paper", -32.0, 0.3, 0.0], "page": ["paper", -30.0, 0.3, 0.0]
}
var streams: Dictionary = {}
var layers: Dictionary = {}
var world_voices: Array[AudioStreamPlayer2D] = []
var ui_voices: Array[AudioStreamPlayer] = []
var rng := RandomNumberGenerator.new()
var cooldowns: Dictionary = {}
var room: Node
var world_audio: Node2D
var judy: CharacterBody2D
var robot: CharacterBody2D
var hud: CanvasLayer
var previous_feet := Vector2.ZERO
var step_distance := 0.0
var walking := false
var activity := ""
var activity_wait := 0.0
var typing_on := false
var typing_wait := 0.0
var last_task_serial := -1
var suppress_depth := 0
var ui_wait := 0.0
var fridge_close_after := 0.0
var mess_snapshot: Dictionary = {}
var water_stage := 0
var music: AudioStreamPlayer
var music_gain := 0.0


func _ready() -> void:
	process_mode = Node.PROCESS_MODE_ALWAYS
	rng.randomize()
	for key in FILES:
		streams[key] = load(ROOT + FILES[key])
	for index in range(3):
		var voice := AudioStreamPlayer.new()
		voice.bus = "SFX"
		add_child(voice)
		ui_voices.append(voice)
	music = AudioStreamPlayer.new()
	music.bus = "Music"
	music.volume_db = -80.0
	add_child(music)
	# Read the source directly when available, even before editor import finishes.
	# Exported builds can instead use the imported/remapped resource.
	var theme_stream: AudioStreamOggVorbis
	if FileAccess.file_exists(APARTMENT_THEME_PATH):
		theme_stream = AudioStreamOggVorbis.load_from_file(APARTMENT_THEME_PATH)
	elif ResourceLoader.exists(APARTMENT_THEME_PATH):
		theme_stream = load(APARTMENT_THEME_PATH) as AudioStreamOggVorbis
	if theme_stream != null:
		theme_stream.loop = true
		theme_stream.loop_offset = 0.0
		play_music(theme_stream)
	else:
		push_warning("Apartment music could not be loaded; other audio remains available.")
	get_tree().node_added.connect(_watch_control)
	for node in get_tree().root.find_children("*", "BaseButton", true, false):
		_watch_control(node)
	GameState.state_changed.connect(_activity_state_changed)


func _watch_control(node: Node) -> void:
	if node is BaseButton and not node.has_meta("cozy_audio"):
		node.set_meta("cozy_audio", true)
		node.pressed.connect(play_ui.bind("click"))


func _attach_room(scene: Node) -> void:
	room = scene
	judy = room.get_node("Player")
	robot = room.get_node("TipTop")
	hud = room.get_node("HUD")
	world_audio = Node2D.new()
	world_audio.name = "ApartmentAudio"
	world_audio.process_mode = Node.PROCESS_MODE_ALWAYS
	room.add_child(world_audio)
	var listener := AudioListener2D.new()
	judy.add_child(listener)
	listener.make_current()
	for index in range(6):
		var voice := AudioStreamPlayer2D.new()
		voice.bus = "SFX"
		voice.max_distance = 230.0
		voice.attenuation = 0.65
		voice.panning_strength = 0.5
		world_audio.add_child(voice)
		world_voices.append(voice)
	for key in ["room", "fridge", "tap", "servo", "mosquito", "typing"]:
		var layer := Node2D.new()
		layer.set_script(LAYER)
		world_audio.add_child(layer)
		layer.call("setup", streams[key], "Ambience" if key in ["room", "fridge"] else "SFX", key != "room", 2.0 if key in ["room", "tap"] else 0.0, 18.0 if key == "room" else 8.0)
		layers[key] = layer
	previous_feet = judy.global_position
	step_distance = 0.0
	walking = false
	last_task_serial = -1
	mess_snapshot = GameState.chore_mess.duplicate()
	water_stage = int(GameState.sink_water_elapsed / 8.0)
	fridge_close_after = 0.0


func _world_allowed() -> bool:
	return is_instance_valid(room) and is_instance_valid(hud) and not get_tree().paused and not bool(hud.get("transitioning")) and not GameState.day_ended and not GameState.game_finished and suppress_depth == 0 and not GameState.activity_skip_busy


func _process(delta: float) -> void:
	_update_music(delta)
	ui_wait = maxf(0.0, ui_wait - delta)
	for key in cooldowns:
		cooldowns[key] = maxf(0.0, float(cooldowns[key]) - delta)
	_tick_voices(ui_voices, delta)
	var scene: Node = get_tree().current_scene
	if scene != room or not is_instance_valid(room):
		if is_instance_valid(world_audio):
			world_audio.queue_free()
		world_voices.clear()
		layers.clear()
		activity = ""
		room = null
		if is_instance_valid(scene) and scene.has_node("Player") and scene.has_node("TipTop") and scene.has_node("HUD"):
			_attach_room(scene)
	if not is_instance_valid(room):
		return
	_tick_voices(world_voices, delta)
	var active := _world_allowed()
	if not active:
		for voice in world_voices:
			voice.stop()
	var sink: Node2D = room.get_node("Sink")
	layers["room"].call("set_level", -29.0, active)
	layers["fridge"].global_position = room.get_node("Fridge").global_position
	layers["fridge"].call("set_level", -29.0, active)
	layers["tap"].global_position = sink.global_position
	layers["tap"].call("set_level", -21.0, active and GameState.tap_running)
	layers["servo"].global_position = robot.global_position
	# Physics velocity persists between render frames, including at 120 Hz.
	var robot_moving := robot.velocity.length() > 2.0
	layers["servo"].call("set_level", -24.0, active and robot_moving)
	var nearest := INF
	var fly_position := sink.global_position
	for id in GameState.mosquitoes:
		var point: Vector2 = GameState.mosquitoes[id]["position"]
		var distance := judy.global_position.distance_to(point)
		if distance < nearest:
			nearest = distance
			fly_position = point
	layers["mosquito"].global_position = fly_position
	layers["mosquito"].call("set_level", -28.0, active and nearest < 45.0)
	layers["typing"].global_position = room.get_node("Desk").global_position
	if not active:
		layers["typing"].call("set_level", -19.0, false)
		previous_feet = judy.global_position
		walking = false
		step_distance = 0.0
		return
	_update_steps(delta)
	if fridge_close_after > 0:
		fridge_close_after = maxf(0.0, fridge_close_after - delta)
		if fridge_close_after == 0:
			play_world("fridge_close", room.get_node("Fridge").global_position)
	_update_activity(delta)
	_update_robot()


func _update_steps(_delta: float) -> void:
	var distance := judy.global_position.distance_to(previous_feet)
	previous_feet = judy.global_position
	if distance > 12.0 or not judy.get_node("Visual").visible or judy.velocity.length() < 5.0:
		step_distance = 0.0
		walking = false
		return
	if not walking and distance > 0.001:
		walking = true
		step_distance = 0.0
		# Start on the first actual movement, not after walking 24 units.
		cooldowns.erase("step")
		play_world("step", judy.global_position)
		return
	step_distance += distance
	if step_distance >= 24.0:
		step_distance = fmod(step_distance, 24.0)
		play_world("step", judy.global_position)


func _update_activity(delta: float) -> void:
	var current := "research" if GameState.research_active else GameState.personal_activity
	if current != activity:
		stop_activity()
		activity = current
		activity_wait = 0.5
		typing_on = current == "research"
		typing_wait = rng.randf_range(4.0, 7.0)
		if current == "research":
			play_world("desk", judy.global_position, true)
	if activity == "research":
		typing_wait -= delta
		if typing_wait <= 0:
			typing_on = not typing_on
			typing_wait = rng.randf_range(4.0, 8.0) if typing_on else rng.randf_range(0.8, 2.0)
		layers["typing"].call("set_level", -19.0, typing_on)
	else:
		layers["typing"].call("set_level", -19.0, false)
	if activity.is_empty():
		return
	activity_wait -= delta
	if activity_wait > 0:
		return
	# Cadence stays in real seconds at 1x and 6x; pitch never follows playback.
	var cue: String = {"research": "paper", "eat": "meal", "cube": "cube", "reels": "phone", "games": "phone"}[activity]
	if activity == "eat" and rng.randf() < 0.4:
		cue = "eating"
	play_world(cue, judy.global_position, true)
	if activity == "research":
		activity_wait = rng.randf_range(9.0, 16.0)
	elif activity == "eat":
		activity_wait = rng.randf_range(5.0, 9.0)
	else:
		activity_wait = rng.randf_range(3.0, 6.0)


func _update_robot() -> void:
	if str(robot.get("task_outcome")) != "working":
		return
	var serial: int = robot.get("session_serial")
	if serial == last_task_serial:
		return
	last_task_serial = serial
	if bool(robot.get("swatting")):
		return # The actual successful removal supplies its one swat sound.
	var cue: String = {"sink": "meal", "plant": "watering", "bookshelf": "books", "bed": "bedding"}.get(GameState.research_task, "clean")
	if bool(robot.get("cleanup_target")):
		cue = "books" if GameState.research_task == "bookshelf" else ("bedding" if GameState.research_task == "bed" else "clean")
	play_world(cue, robot.global_position)


func _activity_state_changed() -> void:
	if not GameState.research_active and GameState.personal_activity.is_empty():
		var finished_work := activity == "research"
		stop_activity()
		if finished_work and is_instance_valid(judy):
			play_world("desk", judy.global_position)
	if not is_instance_valid(room):
		return
	for chore in ["bookshelf", "plant", "bed"]:
		var level: int = GameState.chore_mess[chore]
		if level > int(mess_snapshot.get(chore, level)):
			var fixture: String = {"bookshelf": "Bookshelf", "plant": "PlantPot", "bed": "Bed"}[chore]
			var cue: String = {"bookshelf": "book_fall", "plant": "drip", "bed": "bedding"}[chore]
			play_world(cue, room.get_node(fixture).global_position)
		mess_snapshot[chore] = level
	var stage := int(GameState.sink_water_elapsed / 8.0)
	if stage > water_stage and GameState.tap_running:
		play_world("drip", room.get_node("Sink").global_position)
	water_stage = stage


func fridge_access() -> void:
	if not _world_allowed():
		return
	play_world("fridge_open", room.get_node("Fridge").global_position)
	fridge_close_after = 3.0


func stop_activity() -> void:
	if layers.has("typing") and is_instance_valid(layers["typing"]):
		layers["typing"].call("stop_now")
	for voice in world_voices:
		if is_instance_valid(voice) and bool(voice.get_meta("activity", false)):
			voice.stop()
	activity = ""


func begin_instant() -> void:
	suppress_depth += 1
	stop_activity()
	for voice in world_voices:
		voice.stop()


func end_instant() -> void:
	suppress_depth = maxi(0, suppress_depth - 1)
	if is_instance_valid(robot):
		last_task_serial = int(robot.get("session_serial"))


func play_world(cue: String, point: Vector2, for_activity: bool = false) -> void:
	if not _world_allowed() or GameState.time_category != "misc" or float(cooldowns.get(cue, 0.0)) > 0:
		return
	var spec: Array = CUES.get(cue, [])
	if cue == "step":
		spec = ["step_%d" % rng.randi_range(0, 2), -19.0, 0.6, 0.0]
	if spec.is_empty():
		return
	for voice in world_voices:
		if not voice.playing:
			voice.global_position = point
			_start_voice(voice, spec, for_activity)
			cooldowns[cue] = 0.28 if cue == "step" else 1.5
			return


func play_ui(cue: String = "click", completion: bool = false) -> void:
	if (ui_wait > 0 and not completion) or not CUES.has(cue) or suppress_depth > 0 or GameState.activity_skip_busy:
		return
	for voice in ui_voices:
		if not voice.playing:
			_start_voice(voice, CUES[cue], false)
			ui_wait = 0.14
			return


func _start_voice(voice: Node, spec: Array, for_activity: bool) -> void:
	var source: AudioStream = streams[spec[0]]
	voice.set("stream", source)
	voice.set("pitch_scale", rng.randf_range(0.98, 1.02))
	voice.set_meta("gain", float(spec[1]) + rng.randf_range(-1.0, 1.0))
	voice.set_meta("age", 0.0)
	voice.set_meta("duration", minf(float(spec[2]), source.get_length() - float(spec[3])))
	voice.set_meta("activity", for_activity)
	# Preserve the recorded attack; starting muted loses very short clicks
	# before the next render-frame envelope update.
	voice.set("volume_db", float(voice.get_meta("gain")))
	voice.call("play", float(spec[3]))


func _tick_voices(voices: Array, delta: float) -> void:
	for voice in voices:
		if not is_instance_valid(voice) or not bool(voice.get("playing")):
			continue
		var age: float = float(voice.get_meta("age", 0.0)) + delta
		var duration: float = voice.get_meta("duration", 0.5)
		voice.set_meta("age", age)
		if age >= duration:
			voice.call("stop")
		else:
			var envelope := minf(1.0, minf(age / 0.015, (duration - age) / 0.06))
			voice.set("volume_db", float(voice.get_meta("gain")) + linear_to_db(maxf(0.0001, envelope)))


func play_music(stream: AudioStream) -> void:
	if music.stream == stream:
		return
	music.stop()
	music.stream = stream
	if stream == null:
		music.stop()
	else:
		music.play()


func _update_music(delta: float) -> void:
	# One persistent player: menus, Watch/6x/Skip and day changes never seek it.
	var target_db := -27.0
	var silent: bool = SaveStore.loading
	var scene: Node = get_tree().current_scene
	if is_instance_valid(scene) and scene.has_node("HUD"):
		var current_hud: Node = scene.get_node("HUD")
		silent = silent or bool(current_hud.get("transitioning"))
		var evening := clampf((GameState.time_minutes + GameState.clock_fraction + GameState.world_accumulator - 1020.0) / 180.0, 0, 1)
		target_db = -23.0 - evening * 2.0
		if GameState.game_finished:
			target_db = -25.0 if current_hud.get("ending_kind") == "good" else (-28.0 if current_hud.get("ending_kind") == "bittersweet" else -30.0)
		elif get_tree().paused:
			target_db = -32.0 if current_hud.call("_pause_open") else -29.0
		if current_hud.get("dialogue_overlay") != null and current_hud.get("dialogue_overlay").visible:
			target_db = minf(target_db, -31.0)
	var target := 0.0 if silent else db_to_linear(target_db)
	music_gain = lerpf(music_gain, target, 1.0 - exp(-delta * (5.0 if silent else 1.8)))
	music.volume_db = linear_to_db(maxf(0.0001, music_gain))
