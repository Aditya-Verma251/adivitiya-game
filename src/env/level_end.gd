extends Node2D

var winScreen : PackedScene = preload("res://src/levels/win_screeen.tscn")

func _on_end_area_body_entered(body: Node2D) -> void:
	if body.name == "Player":
		get_tree().change_scene_to_packed(winScreen)
