extends Node2D

var player

func _ready() -> void:
	player = preload("res://src/player.tscn")
	$Player._on_main_mpu()
	
