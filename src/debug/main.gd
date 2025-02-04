extends Node2D

signal mpu
var b = 1.0

func _ready() -> void:
	'''$Player/Camera2D.limit_bottom = 645
	$Player/Camera2D.limit_top = -645
	$Player/Camera2D.limit_left = -1200
	$Player/Camera2D.limit_right = 1200'''
	$Player.isInputFixed = false

func _process(delta: float) -> void:
	if Input.is_action_just_pressed("special"): #'''&& b >= 1'''
		mpu.emit()
		b = 0
	else:
		b += delta
		
	if Input.is_action_just_pressed("nlevel"):
		get_tree().change_scene_to_file("res://src/level_0.tscn")
