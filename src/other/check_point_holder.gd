extends Node

var checkpoint : Vector2
var exists : bool = false

func _ready() -> void:
	exists = false

func setCheckpoint(v : Vector2):
	checkpoint = v
	
func getCheckpoint():
	return checkpoint
