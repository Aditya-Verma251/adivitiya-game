extends Node2D

var player

func _ready() -> void:
	player = preload("res://src/player.tscn")
	$Player._on_main_mpu()
	


func _on_glitch_trigger_body_entered(body: Node2D) -> void:
	if body.name == "Player":
		
	pass # Replace with function body.
