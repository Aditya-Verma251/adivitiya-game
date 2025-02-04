extends CharacterBody2D

@export var health : float = 100.0
@export var g = Vector2(0, 98)
var og
@export var ospeed = 300.0
@export var dashSpeed = 2000.0
@export var max_speed = 1000.0
@export var damageValue = 50.0
var speed = 300.0
var justDashed = false
var endDash = false
#@export var dashTime : float
@export var jt = 1.0
@export var acc = 0.0
@export var jump_velocity = -400.0
static var isInputFixed = true
var isJumping 
var isRunning
var isIdle
var direction

func _ready() -> void:
	$SwordAnim.visible = false
	$CollisionShape2D/AnimatedSprite2D.play()
	$Sword.collision_layer = 32
	$Sword.collision_mask = 32
	og = g

func swing():
	if direction > 0:
		$Sword.position.x = 100
		$SwordAnim.flip_h = false
		$SwordAnim.position.x = 100
		
	else:
		$Sword.position.x = -100
		$SwordAnim.flip_h = true
		$SwordAnim.position.x = -100
	
	$Sword.collision_layer = 1
	$Sword.collision_mask = 1
	
	$SwordAnim.visible = true
	$SwordAnim.play()
	$SwordTimer.start()

func _process(delta: float) -> void:
	if Input.is_action_just_pressed("attack"):
		swing()

func _physics_process(delta: float) -> void:
	# Add the gravity.
	print(ospeed, "   ",  max_speed, "   ", speed, "   ", acc, "   ", jump_velocity, "   ", jt)
	if not is_on_floor():
		velocity += g * delta
		#speed *= 0.8
		'''jt += delta'''
	else:
		isJumping = false
		pass
		#speed /= 0.8
		#jt = 0'''

	# Handle jump.
	if Input.is_action_just_pressed("jump") and is_on_floor() and isInputFixed:
		velocity.y = jump_velocity
		isJumping = true
		isRunning = false
		isIdle = false
		if $CollisionShape2D/AnimatedSprite2D.is_playing():
			$CollisionShape2D/AnimatedSprite2D.stop()
		
		$CollisionShape2D/AnimatedSprite2D.animation = "jump"
		$CollisionShape2D/AnimatedSprite2D.play()

	
	#Input.get_axis()
	# Get the input direction and handle the movement/deceleration.
	# As good practice, you should replace UI actions with custom gameplay actions.
	direction = Input.get_axis("larrow", "rarrow") if isInputFixed else Input.get_axis("rarrow", "larrow")
	if direction:
		if not isJumping and not isRunning:
			if $CollisionShape2D/AnimatedSprite2D.is_playing():
				$CollisionShape2D/AnimatedSprite2D.stop()
			
			if direction < 0:
				$CollisionShape2D/AnimatedSprite2D.flip_h = true
			elif direction > 0:
				$CollisionShape2D/AnimatedSprite2D.flip_h = false
			else:
				pass
			
			$CollisionShape2D/AnimatedSprite2D.animation = "run"
			$CollisionShape2D/AnimatedSprite2D.play()
			isRunning = true
			isIdle = false
		else:
			isRunning = false
			isIdle = true
		
		if speed < max_speed:
			speed += acc
		elif endDash:
			pass
		else:
			speed = max_speed

		if Input.is_action_just_pressed("dash") and not justDashed:
			print("dash")
			velocity.y = 0
			speed +=  dashSpeed
			g = Vector2.ZERO
			justDashed = true
			endDash = true
			$DashTimer.start()
			$DashTime.start()
		
		velocity.x = direction * speed

	elif isIdle:
		if $CollisionShape2D/AnimatedSprite2D.is_playing():
			$CollisionShape2D/AnimatedSprite2D.stop()
		
		$CollisionShape2D/AnimatedSprite2D.animation = "idle"
		$CollisionShape2D/AnimatedSprite2D.play()
		velocity.x = move_toward(velocity.x, 0, speed)
		speed = 0
	else:
		pass

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


func _on_dash_timer_timeout() -> void:
	justDashed = false # Replace with function body.


func _on_dash_time_timeout() -> void:
	g = og
	endDash = false# Replace with function body.


func _on_sword_body_entered(body: Node2D) -> void:
	if body.has_method("takeDamage"):
		body.takeDamage(damageValue) # Replace with function body.
	
	if body.has_method("destroyBullet"):
		body.destroyBullet()


func _on_sword_timer_timeout() -> void:
	$Sword.collision_layer = 32
	$Sword.collision_mask = 32
	
	$SwordAnim.visible = false
	if $SwordAnim.is_playing():
		$SwordAnim.stop() # Replace with function body.
