extends Node2D

var player

func glitchCutscene() -> void:
	pass

func _ready() -> void:
	player = preload("res://src/player/player.tscn")
	

func _on_glitch_trigger_body_entered(body: Node2D) -> void:
	if body.name == "Player":
		glitchCutscene()
	pass # Replace with function body.
