extends Node2D

@export var flipped = false

func _process(_delta: float) -> void:
		$Facing.position = Vector2.LEFT if flipped else Vector2.RIGHT


func _on_flip(dir: Vector2) -> void:
	print(dir) # Replace with function body.
