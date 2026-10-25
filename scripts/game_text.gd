extends Node

# Presentation only. JSON is read lazily too, so autoload/scene initializers are
# safe even before _ready. No campaign, profile, audio or clock state is changed.
const DIRECTORY := "res://data/text/"
const FILES := ["main_menu", "hud", "research", "activities", "tiptop", "dialogue", "tutorial", "rules", "notifications", "endings", "settings", "save_load", "interactions"]
var entries: Dictionary = {}
var warnings: Dictionary = {}
var message_tags: Dictionary = {}
var button_cues: Dictionary = {}
var loaded := false
var placeholders := RegEx.new()
var format_pattern := RegEx.new()


func _init() -> void:
	_ensure_loaded()


func _ready() -> void:
	if DisplayServer.get_name() != "headless":
		DisplayServer.window_set_title(get_text("main_menu.window_title"))
	get_tree().node_added.connect(_node_added)


func _warn_once(key: String, detail: String) -> void:
	if not warnings.has(key):
		warnings[key] = true
		push_warning("GameText: " + detail)


func _ensure_loaded() -> void:
	if loaded:
		return
	loaded = true
	placeholders.compile("\\{([A-Za-z_][A-Za-z0-9_]*)\\}")
	format_pattern.compile("^%[-+0 #]*[0-9]*(\\.[0-9]+)?[sdif]$")
	for category in FILES:
		var path: String = DIRECTORY + category + ".json"
		var file := FileAccess.open(path, FileAccess.READ)
		if file == null:
			_warn_once(path, "Cannot read " + path + "; missing entries display their IDs.")
			continue
		var parser := JSON.new()
		if parser.parse(file.get_as_text()) != OK or not parser.data is Dictionary:
			_warn_once(path, "Invalid JSON in %s, line %d: %s" % [path, parser.get_error_line(), parser.get_error_message()])
			continue
		for identifier in parser.data:
			var record: Variant = parser.data[identifier]
			if not identifier is String or not record is Dictionary or not record.get("text") is String:
				_warn_once(path + str(identifier), "Invalid text record: " + str(identifier))
				continue
			if str(record["text"]).strip_edges().is_empty():
				# Some existing eligibility APIs return an empty string only when
				# an action is safe. Empty copy must never bypass those checks.
				_warn_once(identifier, "Empty text is not supported: " + identifier)
				continue
			if not record.get("variables", {}) is Dictionary or not record.get("order", []) is Array:
				_warn_once(identifier, "Invalid variables/order: " + identifier)
				continue
			if entries.has(identifier):
				_warn_once(identifier, "Duplicate ID: " + identifier)
				continue
			entries[identifier] = record


func get_text(identifier: String, values: Dictionary = {}) -> String:
	_ensure_loaded()
	if not entries.has(identifier):
		_warn_once(identifier, "Missing ID: " + identifier)
		return "[" + identifier + "]"
	var record: Dictionary = entries[identifier]
	var text: String = record["text"]
	var formats: Dictionary = record.get("variables", {})
	for token in placeholders.search_all(text):
		var name: String = token.get_string(1)
		if not values.has(name):
			_warn_once(identifier + ":" + name, "Missing value {%s} for %s" % [name, identifier])
			continue # Leave the visible placeholder intact; never drop words.
		var value: Variant = values[name]
		var rendered := str(value)
		if formats.has(name):
			var spec: Variant = formats[name]
			if not spec is String or format_pattern.search(spec) == null:
				_warn_once(identifier + ":format:" + name, "Invalid numeric format for " + identifier + ":" + name)
			elif spec.ends_with("s"):
				rendered = spec % str(value)
			elif (value is int or value is float) and is_finite(float(value)):
				rendered = spec % value
			else:
				_warn_once(identifier + ":type:" + name, "Expected a number for " + identifier + ":" + name)
		text = text.replace(token.get_string(), rendered)
	# Character identity is metadata, never inferred from editable prose.
	var speaker: String = str(record.get("speaker", ""))
	if not speaker.is_empty():
		text = speaker + ": " + text
	var tags: Variant = record.get("tags", [])
	if tags is Array and not tags.is_empty():
		message_tags[text] = tags
	var cue: String = str(record.get("audio_cue", ""))
	if not cue.is_empty():
		button_cues[text] = cue
	return text


func format_text(identifier: String, arguments: Variant) -> String:
	_ensure_loaded()
	if not entries.has(identifier):
		return get_text(identifier)
	var supplied: Array = arguments if arguments is Array else [arguments]
	var order: Array = entries[identifier].get("order", [])
	var values := {}
	if supplied.size() != order.size():
		_warn_once(identifier + ":count", "Value count mismatch for " + identifier)
	for index in range(mini(supplied.size(), order.size())):
		if order[index] is String:
			values[order[index]] = supplied[index]
	return get_text(identifier, values)


func has_tag(message: String, tag: String) -> bool:
	return tag in message_tags.get(message, [])


func button_cue(caption: String) -> String:
	return str(button_cues.get(caption, "click"))


func _node_added(node: Node) -> void:
	if node is Control:
		node.ready.connect(_bind_scene_text.bind(node), CONNECT_ONE_SHOT)


func _bind_scene_text(control: Control) -> void:
	# @ID is a scene binding, not translated copy or a gameplay identifier.
	if control is Label or control is Button or control is RichTextLabel:
		var value: String = str(control.get("text"))
		if value.begins_with("@"):
			control.set("text", get_text(value.substr(1)))
	for property in ["tooltip_text", "accessibility_name", "accessibility_description"]:
		var value: String = str(control.get(property))
		if value.begins_with("@"):
			control.set(property, get_text(value.substr(1)))
