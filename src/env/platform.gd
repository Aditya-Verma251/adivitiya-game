extends StaticBody2D

@export var isReal = true
# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	if !isReal:
		collision_layer = 32
		collision_mask = 32
	pass # Replace with function body.
