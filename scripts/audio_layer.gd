extends Node2D

# Two reusable voices overlap recorded excerpts, avoiding hard loop seams.
var voices: Array[Node] = []
var source: AudioStream
var start := 0.0
var length := 8.0
var overlap := 0.65
var enabled := false
var level_db := -30.0
var gain := 0.0
var current := 0
var age := 0.0
var mixing := false
var mix_age := 0.0


func setup(stream: AudioStream, bus: String, spatial: bool, begin: float = 0.0, duration: float = 16.0) -> void:
	source = stream
	start = minf(begin, maxf(0.0, stream.get_length() - 1.0))
	length = minf(duration, stream.get_length() - start)
	overlap = minf(0.65, length * 0.2)
	for index in range(2):
		var voice: Node = AudioStreamPlayer2D.new() if spatial else AudioStreamPlayer.new()
		voice.set("stream", source)
		voice.set("bus", bus)
		voice.set("volume_db", -80.0)
		if spatial:
			voice.set("max_distance", 230.0)
			voice.set("attenuation", 0.65)
			voice.set("panning_strength", 0.5)
		add_child(voice)
		voices.append(voice)


func set_level(db: float, audible: bool) -> void:
	level_db = db
	enabled = audible


func stop_now() -> void:
	enabled = false
	gain = 0.0
	for voice in voices:
		voice.call("stop")
	age = 0.0
	mixing = false


func _process(delta: float) -> void:
	if voices.is_empty():
		return
	gain = move_toward(gain, 1.0 if enabled else 0.0, delta / (0.8 if enabled else 0.15))
	if gain <= 0.0001:
		for voice in voices:
			voice.call("stop")
		age = 0.0
		mixing = false
		return
	if not bool(voices[current].get("playing")):
		voices[current].call("play", start)
		age = 0.0
	age += delta
	var next := 1 - current
	if not mixing and age >= length - overlap:
		voices[next].call("play", start)
		mixing = true
		mix_age = 0.0
	if mixing:
		mix_age += delta
		var blend := clampf(mix_age / overlap, 0.0, 1.0)
		voices[current].set("volume_db", linear_to_db(maxf(0.0001, gain * (1.0 - blend))) + level_db)
		voices[next].set("volume_db", linear_to_db(maxf(0.0001, gain * blend)) + level_db)
		if blend >= 1.0:
			voices[current].call("stop")
			current = next
			age = mix_age
			mixing = false
	else:
		voices[current].set("volume_db", linear_to_db(maxf(0.0001, gain)) + level_db)
