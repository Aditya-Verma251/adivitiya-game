extends Area2D

@export var g = Vector2.ZERO
signal changeGravity(gravity : Vector2)

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass



func _on_body_entered(body: Node2D) -> void:
	if body.name == "Player":
		changeGravity.emit(g) # Replace with function body.


func _on_body_exited(body: Node2D) -> void:
	changeGravity.emit(g) # Replace with function body.
