extends Node

signal playerFinalAccept
var toListen : bool

func listen():
	toListen = true

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	if toListen and Input.is_action_just_pressed("confirm"):
		toListen = false
		playerFinalAccept.emit()
