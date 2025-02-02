extends CharacterBody2D

@export var time :float
var proj = preload("res://src/enemy2projectile.tscn")
var toShoot = false
var player

func shoot() -> void:
	var projectile = proj.instantiate()
	var d : Vector2 = player.position - position
	d.normalized()
	projectile.setException(name)
	projectile.move(d * 0.01)
	$ProjectileContainer.add_child(projectile)

func _ready() -> void:
	$TimePeriod.one_shot = false
	$TimePeriod.wait_time = time

	
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
		
