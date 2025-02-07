extends CharacterBody2D

@export var health : int = 1
@export var blinks : int = 3
@export var blinkCount : int = blinks
@export var time :float
@export var bSpeed = 0.01
@export var damageValue : int
var proj = preload("res://src/enemies/enemy2projectile.tscn")
var toShoot = false
var player
var rng = RandomNumberGenerator.new()

func shoot() -> void:
	var projectile = proj.instantiate()
	var d : Vector2 = player.position - position
	projectile.rotation = acos(d.normalized().x)
	d.normalized()
	projectile.setException(name)
	projectile.move(d.normalized() * bSpeed)
	$ProjectileContainer.add_child(projectile)
	$AudioStreamPlayer2D.play()

func _ready() -> void:
	$EnemyExplosion.visible = false
	$TimePeriod.one_shot = false
	if time > 0.05:
		$TimePeriod.wait_time = time

	

func takeDamage(value):
	health -= value
	set_collision_layer_value(2, false)
	set_collision_mask_value(1, false)
	set_collision_mask_value(2, false)
	$Sprite2D.visible = false
	blinkCount -= 1
	if health <= 0:
		die()
	else:
		$DamageTime.start()

func _process(delta: float) -> void:
	pass
	
func _physics_process(delta: float) -> void:
	pass
	


func _on_time_period_timeout() -> void:
	if toShoot:
		shoot()
	


func _on_area_2d_body_entered(body: Node2D) -> void:
	if body.name == "Player":
		player = body
		shoot()
		toShoot = true

	


func _on_area_2d_body_exited(body: Node2D) -> void:
	if body.name == "Player":
		toShoot = false 
		


func _on_area_2d_2_body_entered(body: Node2D) -> void:
	if body.name == "Player":
		PlayerDamageController.playerDamage.emit(damageValue)

func die():
	$Sprite2D.visible = false
	$EnemyExplosion.visible = true
	if $AudioStreamPlayer2D.playing:
		$AudioStreamPlayer2D.stop()
		
	if rng.randi() % 2 == 0:
		$Explosion/AudioStreamPlayer2D.play()
	else:
		$Explosion/AudioStreamPlayer2D2.play()
	$EnemyExplosion.play()
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


func _on_enemy_explosion() -> void:
	queue_free()
