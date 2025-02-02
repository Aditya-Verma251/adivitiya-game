extends CharacterBody2D
 

signal damage(damage:float)

@export var dmg = 40
@export var speed = 400.0
@export var moveRight = true
@export var time :float
@export var starting : int

func _ready() -> void:
	$TimePeriod.one_shot = false
	$TimePeriod.wait_time = time
	if moveRight:
		speed = -speed
	$Sprite2D.flip_h = not $Sprite2D.flip_h
	#position.x = starting 
	
func _process(_delta: float) -> void:
	pass
	
func _physics_process(_delta: float) -> void:
	velocity.x = speed
	move_and_slide()
	


func _on_time_period_timeout() -> void:
	speed = -speed
	$Sprite2D.flip_h = not$Sprite2D.flip_h
	
	


func _on_area_2d_body_entered(body: Node2D) -> void:
	if body.name == "Player":
		damage.emit(dmg) # Replace with function body.
