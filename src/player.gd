extends CharacterBody2D

@export var health : float = 100.0
@export var g = Vector2(0, 98)
@export var ospeed = 300.0
@export var dashSpeed = 2000.0
@export var max_speed = 1000.0
var speed = 300.0
@export var jt = 1.0
@export var acc = 0.0
@export var jump_velocity = -400.0
static var isInputFixed = true

func _ready() -> void:
	$CollisionShape2D/AnimatedSprite2D.play()

func _physics_process(delta: float) -> void:
	# Add the gravity.
	print(ospeed, "   ",  max_speed, "   ", speed, "   ", acc, "   ", jump_velocity, "   ", jt)
	if not is_on_floor():
		velocity += g * delta
		#speed *= 0.8
		'''jt += delta'''
	else:
		pass
		#speed /= 0.8
		#jt = 0'''

	# Handle jump.
	if Input.is_action_just_pressed("jump") and is_on_floor() and isInputFixed:
		velocity.y = jump_velocity

	
	#Input.get_axis()
	# Get the input direction and handle the movement/deceleration.
	# As good practice, you should replace UI actions with custom gameplay actions.
	var direction := Input.get_axis("larrow", "rarrow") if isInputFixed else Input.get_axis("rarrow", "larrow")
	if direction:
		if speed < max_speed:
			speed += acc
		else:
			speed = max_speed
		
		velocity.x = direction * speed
	else:
		velocity.x = move_toward(velocity.x, 0, speed)
		speed = 0

	move_and_slide()


func _on_main_mpu() -> void:
	isInputFixed = !isInputFixed
	
func _on_change_gravity(grav : Vector2) -> void:
	g = grav

func _on_damage(damage: float) -> void:
	health -= damage
	print("damage taken")
	if health < 0:
		gameOver() # Replace with function body.

func gameOver() -> void:
	pass
