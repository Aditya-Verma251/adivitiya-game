extends CharacterBody2D
class_name Player

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
static var isPositionFixed = GlobalVariables.isPositionFixed
@export var limits : Vector4
@export var glitchTimerLimits : Vector2 #x is lower limit and y is upper limit
@export var fallingGravityScale : float = 1.75
var isJumping = false 
var isRunning = false
var isDashing = false
var direction
var Anim : AnimatedSprite2D
var CoyoteTimer : Timer
var coyoteTimeEnd : bool = false
var DashTime : Timer #how long dash lasts
var DashTimer : Timer # time between dashes (from the start of first dash)
var Facing : Node2D
var canDash : bool = true

func _ready() -> void:
	if glitchTimerLimits.x < 0.05:
		glitchTimerLimits.x = 0.06
		
	if glitchTimerLimits.y < 0.05:
		glitchTimerLimits.y = 0.06
	
	Facing = $Center/Facing
	Anim = $AnimatedSprite2D
	CoyoteTimer = $CoyoteTime
	DashTime = $DashTime
	DashTimer = $DashTimer
	$MovementStateHandler.init(self, Anim)
	
	SignalManager.playerDamage.connect(_on_player_damage)
	SignalManager.glitchyPosition.connect(_on_glitchy_position)
	SignalManager.teleport.connect(_on_teleport)
	
	$AnimatedSprite2D.animation = "idle"
	$AnimatedSprite2D.play()
	og = g
	$AudioListener2D.make_current()
	if isPositionFixed:
		if not $GlitchTimer.is_stopped():
			$GlitchTimer.stop()
	else:
		if $GlitchTimer.is_stopped():
			$GlitchTimer.wait_time = rng.randf_range(glitchTimerLimits.x, glitchTimerLimits.y)
			$GlitchTimer.start()

func getDirection():
	return Input.get_axis("larrow", "rarrow") if isInputFixed else Input.get_axis("rarrow", "larrow")
	
func setGlitchyPosition():
	if !isPositionFixed:
		position += Vector2(rng.randf_range(limits.w, limits.x), rng.randf_range(limits.y, limits.z))
		#w and x are -ve and +ve limits on x axis. y and z are -ve and +ve limits on y axis.

func switchGlitchyPosition():
	isPositionFixed = !isPositionFixed
	GlobalVariables.isPositionFixed = !GlobalVariables.isPositionFixed
	if isPositionFixed:
		if not $GlitchTimer.is_stopped():
			$GlitchTimer.stop()
	else:
		if $GlitchTimer.is_stopped():
			$GlitchTimer.wait_time = rng.randf_range(glitchTimerLimits.x, glitchTimerLimits.y)
			$GlitchTimer.start()


func _process(_delta: float) -> void:
	pass

func _physics_process(delta: float) -> void:
	if not is_on_floor():
		velocity.y += g.y * delta
		
	velocity.x += g.x * delta
	
	if not canDash and is_on_floor():
		canDash = true

	direction = getDirection()
	if direction != 0:
		$Center.flipped = direction < 0

	#print(velocity, "	", position)
	move_and_slide()

func _on_change_gravity(grav : Vector2) -> void:
	g = grav

func gameOver() -> void:
	get_tree().change_scene_to_file("res://src/ui_gen/DeathScreen.tscn")

func _on_player_damage(value : int):
	if not GlobalVariables.isPaused:
		health -= value
		set_collision_layer_value(1, false)
		$AnimatedSprite2D.visible = false
		$DamageTimer.start()
		
		if health <= 0:
			gameOver()
			#call_deferred("gameOver")
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

func _on_flip(_dir: Vector2) -> void:
	scale.x = -scale.x # Replace with function body.

func _on_damage_timer_timeout() -> void:
	$AnimatedSprite2D.visible = not $AnimatedSprite2D.visible
	if not $AnimatedSprite2D.visible:
		blinkCount -= 1
		print(blinkCount, "	<-bl		h->	", health)
	
	if blinkCount <= 0:
		if health <= 0:
			$DamageTimer.stop()
			gameOver()
		else:
			blinkCount = blinks
			$AnimatedSprite2D.visible = true
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

func _on_teleport(pos : Vector2):
	print(pos, "teleport")
	position = pos


func _on_coyote_time_timeout() -> void:
	coyoteTimeEnd = true
