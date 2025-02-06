extends CharacterBody2D

@export var damageValue : int = 40
@export var speed = 400.0
@export var moveRight = true
@export var time :float
@export var starting : int
@export var health : int = 1
@export var blinkCount : int = 3

func _ready() -> void:
	$TimePeriod.one_shot = false
	$TimePeriod.wait_time = time
	if moveRight:
		speed = -speed
	$Sprite2D.flip_h = not $Sprite2D.flip_h
	#position.x = starting 

func _physics_process(_delta: float) -> void:
	velocity.x = speed
	move_and_slide()
	

func takeDamage(value):
	health -= value
	if health <= 0:
		die()

func _on_time_period_timeout() -> void:
	speed = -speed
	$Sprite2D.flip_h = not $Sprite2D.flip_h

func die():
	set_collision_layer_value(1, false)
	set_collision_layer_value(2, false)
	set_collision_mask_value(1, false)
	set_collision_mask_value(2, false)
	$Sprite2D.visible = false
	blinkCount -= 1
	$DeathTime.start()

func _on_area_2d_body_entered(body: Node2D) -> void:
	if body.name == "Player":
		PlayerDamageController.playerDamage.emit(damageValue)


func _on_death_time_timeout() -> void:
	$Sprite2D.visible = not $Sprite2D.visible
	if not $Sprite2D.visible:
		blinkCount -= 1
	
	if blinkCount <= 0:
		queue_free() # Replace with function body.
