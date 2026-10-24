extends StaticBody2D

@onready var prompt_label: Label = $PromptLabel
var player_nearby := false


func _ready() -> void:
	# Furniture proportions change; the E interaction range remains 56 x 40.
	$InteractionZone.scale = Vector2.ONE / scale
	prompt_label.texture_filter = CanvasItem.TEXTURE_FILTER_LINEAR
	GameState.state_changed.connect(_update_prompt)
	_update_prompt()


func _update_prompt() -> void:
	var exhausted := GameState.work_sessions_remaining <= 0
	prompt_label.text = "Too exhausted to work" if exhausted else "E - Work"
	prompt_label.modulate = Color.RED if exhausted else Color.GREEN


func _on_interaction_zone_body_entered(body: Node2D) -> void:
	if body.name == "Player":
		player_nearby = true
		GameState.story_event.emit("desk_approach")


func _on_interaction_zone_body_exited(body: Node2D) -> void:
	if body.name == "Player":
		player_nearby = false
		prompt_label.visible = false


