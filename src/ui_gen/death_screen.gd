extends Control

func _on_button_button_up() -> void:
	get_tree().change_scene_to_file("res://src/levels/level_0.tscn")
	SignalManager.teleport.emit(CheckPointHolder.getCheckpoint())
	print("emit")
