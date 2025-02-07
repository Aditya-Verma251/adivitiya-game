extends CharacterBody2D

var rng = RandomNumberGenerator.new()

@export var damageValue : int = 1
@export var speed = 400.0
@export var moveRight = true
@export var time :float
@export var starting : int
@export var health : int = 1
@export var blinks : int = 3
@export var blinkCount : int = blinks

func _ready() -> void:
	$TimePeriod.one_shot = false
	if time > 0.05:
		$TimePeriod.wait_time = time
		
	if moveRight:
		speed = -speed
		
	$Sprite2D.flip_h = not $Sprite2D.flip_h
	$AnimatedSprite2D.visible = false
	$AnimatedSprite2D.stop()
	#position.x = starting 

func _physics_process(_delta: float) -> void:
	velocity.x = speed
	move_and_slide()
	

func takeDamage(value):
	health -= value
	set_collision_layer_value(2, false)
	set_collision_mask_value(1, false)
	set_collision_mask_value(2, false)
	$Area2D.set_collision_layer_value(2, false)
	$Area2D.set_collision_mask_value(1, false)
	$Area2D.set_collision_mask_value(2, false)
	$Sprite2D.visible = false
	blinkCount -= 1
	if health <= 0:
		die()
	else:
		$DamageTime.start()

func _on_time_period_timeout() -> void:
	speed = -speed
	$Sprite2D.flip_h = not $Sprite2D.flip_h

func _on_area_2d_body_entered(body: Node2D) -> void:
	if body.name == "Player":
		PlayerDamageController.playerDamage.emit(damageValue)

func die():
	$Sprite2D.visible = false
	$AnimatedSprite2D.visible = true
	$AnimatedSprite2D.play()
	if rng.randi() % 2 == 0:
		$Explosion/AudioStreamPlayer2D.play()
	else:
		$Explosion/AudioStreamPlayer2D2.play()
	#queue_free()

func _on_damage_time_timeout() -> void:
	$Sprite2D.visible = not $Sprite2D.visible
	if not $Sprite2D.visible:
		blinkCount -= 1
	
	if blinkCount <= 0:
		if health <= 0:
			die()
		else:
			blinkCount = blinks
			$Sprite2D.visible = true
			$DamageTime.stop()
			set_collision_layer_value(2, true)
			set_collision_mask_value(1, true)
			set_collision_mask_value(2, true)
			$Area2D.set_collision_layer_value(2, true)
			$Area2D.set_collision_mask_value(1, true)


func _on_animation_finished() -> void:
	queue_free() # Replace with function body.
