extends State

var Player : Player
var Anim : AnimatedSprite2D
@export var Idle : State
@export var Running : State
@export var Dashing : State
@export var Falling : State

#@export var jumpTime : float
#@export var jumpVelocity : float
var jumpOver : bool = false
#var speed = 0.0
#@export var maximumSpeed : float = 800
#@export var acc : float = 1600
var direction

func _ready() -> void:
	#$JumpTimer.wait_time = jumpTime
	pass

func init(p, a):
	Player = p
	Anim = a

func enter():
	if not Player.CoyoteTimer.is_stopped():
		Player.CoyoteTimer.stop()
	if Anim.is_playing():
		Anim.stop()
	
	Anim.animation = "jump"
	Anim.play()
	Player.velocity.y = Player.jump_velocity
	#$JumpTimer.start()
	jumpOver = false

func state_physics_process(delta:float) -> State:
	if Player.velocity.y >= 0:
		jumpOver = true
	
	if Input.is_action_just_pressed("dash") and Player.canDash:
		return Dashing
	
	if Player.is_on_floor():
		return Idle
	#elif not Player.is_on_floor():
	#	Player.velocity.y += Player.g.y * delta
	
	if Input.is_action_just_released("jump") or jumpOver:
		return Falling
		
		
	direction = Input.get_axis("larrow", "rarrow")
	if direction != 0:
		if Player.speed < Player.max_speed:
			Player.speed += Player.acc * delta
		else:
			Player.speed = Player.max_speed
	else:
		Player.speed = 0
		

	Player.velocity.x = Player.speed * direction
	
	return null

func exit() -> State:
	return null
