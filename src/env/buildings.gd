extends StaticBody2D

@export var sprite:Texture2D
# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	$Sprite2D.texture=sprite


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass
