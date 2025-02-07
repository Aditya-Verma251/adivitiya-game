extends Node2D

func _on_checkpoint_body_entered(body: Node2D) -> void:
	CheckPointHolder.checkpoint = position # Replace with function body.
