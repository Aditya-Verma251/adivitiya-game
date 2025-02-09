extends Node2D

const winScreen : PackedScene = SceneHolder.winScreen

func _on_end_area_body_entered(body: Node2D) -> void:
	print("enter")
	if body.name == "Player":
		get_tree().call_deferred("change_scene_to_packed", winScreen)
