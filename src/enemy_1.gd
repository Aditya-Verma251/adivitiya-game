extends CharacterBody2D
 
@export var speed = 400.0
@export var moveRight = true
@export var time :float
@export var starting : int
func _ready() -> void:
	$TimePeriod.one_shot = false
	$TimePeriod.wait_time = time
	if moveRight:
		speed = -speed
	$Sprite2D.flip_h = not$Sprite2D.flip_h
	#position.x = starting 
	
func _process(delta: float) -> void:
	pass
	
func _physics_process(delta: float) -> void:
	velocity.x = speed
	move_and_slide()
	


func _on_time_period_timeout() -> void:
	speed = -speed
	$Sprite2D.flip_h = not$Sprite2D.flip_h
	
	
