extends Node

func _process(_delta: float) -> void:
	if Input.is_key_pressed(KEY_BACKSPACE):
		get_tree().quit()
