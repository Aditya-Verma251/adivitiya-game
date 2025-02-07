extends CharacterBody2D

var rng = RandomNumberGenerator.new()

@export var health : int = 3
@export var maxHealth : int = 3
@export var blinks : int = 3
@export var blinkCount : int = blinks
@export var g = Vector2(0, 98)
var og
@export var ospeed = 300.0
var ospeed2 = 0.0
@export var dashSpeed = 2000.0
@export var max_speed = 1000.0
@export var damageValue : int = 1
var speed = 0.0
var running_speed : float = 0.0
var justDashed = false
var endDash = false
#@export var dashTime : float
@export var jt = 1.0
@export var acc = 0.0
@export var jump_velocity = -400.0
@export var knockbackDistance = 500
static var isInputFixed = true
static var isPositionFixed = true
@export var limits : Vector4
@export var glitchTimerLimits : Vector2 #x is lower limit and y is upper limit
var isJumping = false 
var isRunning = false
var isDashing = false
var direction

func _ready() -> void:
	if glitchTimerLimits.x < 0.05:
		glitchTimerLimits.x = 0.06
		
	if glitchTimerLimits.y < 0.05:
		glitchTimerLimits.y = 0.06
	
	PlayerDamageController.playerDamage.connect(_on_player_damage)
	PlayerGeneralSignalManager.glitchyPosition.connect(_on_glitchy_position)
	$SwordAnim.visible = false
	$CollisionShape2D/AnimatedSprite2D.animation = "idle"
	$CollisionShape2D/AnimatedSprite2D.play()
	og = g
	$AudioListener2D.make_current()

func getDirection():
	return Input.get_axis("larrow", "rarrow") if isInputFixed else Input.get_axis("rarrow", "larrow")
	
func setGlitchyPosition():
	if !isPositionFixed:
		position += Vector2(rng.randf_range(limits.w, limits.x), rng.randf_range(limits.y, limits.z))
		#w and x are -ve and +ve limits on x axis. y and z are -ve and +ve limits on y axis.

func switchGlitchyPosition():
	isPositionFixed = !isPositionFixed
	if isPositionFixed:
		if not $GlitchTimer.is_stopped():
			$GlitchTimer.stop()
	else:
		if $GlitchTimer.is_stopped():
			$GlitchTimer.wait_time = rng.randf_range(glitchTimerLimits.x, glitchTimerLimits.y)
			$GlitchTimer.start()


func swing():
	$Sword.set_collision_layer_value(1, true)
	$Sword.set_collision_mask_value(2, true)
	$SwordAnim.visible = true
	$SwordAnim.play()
	$SwordTimer.start()

func _process(_delta: float) -> void:
	if not GlobalVariables.isPaused:
		if Input.is_action_just_pressed("attack"):
			swing()

func _physics_process(delta: float) -> void:
	if not GlobalVariables.isPaused:
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
			if $CollisionShape2D/AnimatedSprite2D.animation != "run":
				if $CollisionShape2D/AnimatedSprite2D.is_playing():
					$CollisionShape2D/AnimatedSprite2D.stop()
				$CollisionShape2D/AnimatedSprite2D.animation = "run"
				$CollisionShape2D/AnimatedSprite2D.play()
				
			$Center.flipped = direction < 0
			speed += acc
			isRunning = true
			if speed > max_speed and not isDashing:
				speed = max_speed
		elif not isDashing:
				if $CollisionShape2D/AnimatedSprite2D.animation != "idle":
					if $CollisionShape2D/AnimatedSprite2D.is_playing():
						$CollisionShape2D/AnimatedSprite2D.stop()
					$CollisionShape2D/AnimatedSprite2D.animation = "idle"
					$CollisionShape2D/AnimatedSprite2D.play()
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
	get_tree().change_scene_to_file("res://src/player/DeathScreen.tscn")

func _on_player_damage(value : int):
	if not GlobalVariables.isPaused:
		health -= value
		set_collision_layer_value(1, false)
		$CollisionShape2D/AnimatedSprite2D.visible = false
		$DamageTimer.start()
		
		if health <= 0:
			gameOver()
		elif health > maxHealth:
			health = maxHealth
			
		position.x += (knockbackDistance * (-1 * ($Center/Facing.position.x)))
		$hearts.health_display(health)
		
		print("damage taken")
		print(value)
			
	

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


func _on_damage_timer_timeout() -> void:
	$CollisionShape2D/AnimatedSprite2D.visible = not $CollisionShape2D/AnimatedSprite2D.visible
	if not $CollisionShape2D/AnimatedSprite2D.visible:
		blinkCount -= 1
		print(blinkCount, "	<-bl		h->	", health)
	
	if blinkCount <= 0:
		if health <= 0:
			$DamageTimer.stop()
			gameOver()
		else:
			blinkCount = blinks
			$CollisionShape2D/AnimatedSprite2D.visible = true
			$DamageTimer.stop()
			set_collision_layer_value(1, true)

func _on_glitchy_position():
	switchGlitchyPosition()

func _on_glitch_timer_timeout() -> void:
	setGlitchyPosition()
	
	if not $GlitchTimer.is_stopped():
		$GlitchTimer.stop()
	
	if !isPositionFixed:
		$GlitchTimer.wait_time = randf_range(glitchTimerLimits.x, glitchTimerLimits.y) 
		$GlitchTimer.start()
