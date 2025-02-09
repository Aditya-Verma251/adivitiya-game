extends Node2D

var prevpos
signal flip(dir:Vector2)

func _ready() -> void:
	prevpos = position

func _process(_delta: float) -> void:
	if prevpos != position:
		flip.emit(position)
		
	prevpos = position
