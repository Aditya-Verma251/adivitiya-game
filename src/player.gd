extends CharacterBody2D

@export var ospeed = 300.0
@export var max_speed = 1000.0
var speed = 300.0
@export var acc = 0.0
@export var jump_velocity = -400.0


func _physics_process(delta: float) -> void:
	# Add the gravity.
	print(ospeed, "   ",  max_speed, "   ", speed, "   ", acc, "   ", jump_velocity)
	if not is_on_floor():
		velocity += get_gravity() * delta

	# Handle jump.
	if Input.is_action_just_pressed("jump") and is_on_floor():
		velocity.y = jump_velocity

	# Get the input direction and handle the movement/deceleration.
	# As good practice, you should replace UI actions with custom gameplay actions.
	var direction := Input.get_axis("larrow", "rarrow")
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
