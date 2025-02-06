extends CharacterBody2D

@export var health : float = 100.0
@export var g = Vector2(0, 98)
var og
@export var ospeed = 300.0
var ospeed2 = 0.0
@export var dashSpeed = 2000.0
@export var max_speed = 1000.0
@export var damageValue = 50.0
var speed = 0.0
var running_speed : float = 0.0
var justDashed = false
var endDash = false
#@export var dashTime : float
@export var jt = 1.0
@export var acc = 0.0
@export var jump_velocity = -400.0
static var isInputFixed = true
var isJumping = false 
var isRunning = false
var isDashing = false
var direction

var states = ["", "running", "jumping", "dashing", "changed"]
var current_state = ["", "", "", ""]
var prevstate = ["", ""]

func _ready() -> void:
	PlayerDamageController.playerDamage.connect(_on_player_damage)
	$SwordAnim.visible = false
	$CollisionShape2D/AnimatedSprite2D.animation = "run"
	$CollisionShape2D/AnimatedSprite2D.play()
	og = g

func getDirection():
	return Input.get_axis("larrow", "rarrow") if isInputFixed else Input.get_axis("rarrow", "larrow")

func animHandler(s):
	pass

func swing():
	$Sword.set_collision_layer_value(1, true)
	$Sword.set_collision_mask_value(2, true)
	$SwordAnim.visible = true
	$SwordAnim.play()
	$SwordTimer.start()

func _process(_delta: float) -> void:
	animHandler(current_state)
	if Input.is_action_just_pressed("attack"):
		swing()

func _physics_process(delta: float) -> void:
	var s
	if not is_on_floor():
		velocity.y += g.y * delta
	else:
		isJumping = false
	
	#Input.get_axis()
	# Get the input direction and handle the movement/deceleration.
	# As good practice, you should replace UI actions with custom gameplay actions.
	direction = getDirection()
	if direction != 0:
		$Center.flipped = direction < 0
		speed += acc
		isRunning = true
		if speed > max_speed and not isDashing:
			speed = max_speed
	elif not isDashing:
			isRunning = false
			speed = 0
			
		

	# Handle jump.
	if Input.is_action_just_pressed("jump") and is_on_floor() and isInputFixed:
		velocity.y += jump_velocity
		isJumping = true
		#print(current_state)

	if Input.is_action_just_pressed("dash") and not justDashed:
			print("dash")
			velocity.y = 0
			speed = dashSpeed
			og = g
			g = Vector2.ZERO
			justDashed = true
			isDashing = true
			endDash = false
			$DashTimer.start()
			$DashTime.start()
			

	velocity.x = speed * (direction if direction != 0 else ($Center/Facing.position.x if isInputFixed else -$Center/Facing.position.x)) + g.x
	move_and_slide()


func _on_main_mpu() -> void:
	isInputFixed = !isInputFixed
	
func _on_change_gravity(grav : Vector2) -> void:
	g = grav

func gameOver() -> void:
	pass

func _on_player_damage(value : int):
	health -= value
	if health <= 0:
		gameOver()
	elif health > 4:
		health = 4
		
	

func _on_dash_timer_timeout() -> void:
	justDashed = false # Replace with function body.


func _on_dash_time_timeout() -> void:
	g = og
	endDash = true
	isDashing = false# Replace with function body.


func _on_sword_body_entered(body: Node2D) -> void:
	if body.has_method("takeDamage"):
		body.takeDamage(damageValue) # Replace with function body.


func _on_sword_timer_timeout() -> void:
	$Sword.set_collision_layer_value(1, false)
	$Sword.set_collision_mask_value(2, false)
	
	$SwordAnim.visible = false
	if $SwordAnim.is_playing():
		$SwordAnim.stop() # Replace with function body.


func _on_flip(_dir: Vector2) -> void:
	scale.x = -scale.x # Replace with function body.


func _on_sword_area_entered(area: Area2D) -> void:
	if area.has_method("destroyBullet"):
		print(area)
		area.destroyBullet() # Replace with function body.
