extends Node2D

func _on_checkpoint_body_entered(body: Node2D) -> void:
	if body.name == "Player":
		CheckPointHolder.setCheckpoint(position)
		CheckPointHolder.exists = true
		print(position, CheckPointHolder.exists) # Replace with function body.
