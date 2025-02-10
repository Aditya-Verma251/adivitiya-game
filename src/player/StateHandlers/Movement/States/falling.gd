extends State

var Player : Player
var Anim : AnimatedSprite2D
@export var Idle : State
@export var Running : State
@export var Dashing : State

var direction
#@export var gravityScale : float = 1
var changedGravity : bool = false

func init(p, a):
	Player = p
	Anim = a

func enter():
	if not Player.CoyoteTimer.is_stopped():
		Player.CoyoteTimer.stop()
	Player.velocity.y = 0
	if not Input.is_action_pressed("jump"):
		Player.g.y *= Player.fallingGravityScale
		changedGravity = true

func state_process(delta:float) -> State:
	return null

func state_physics_process(delta:float) -> State:
	if Player.is_on_floor():
		return Idle
	#elif not Player.is_on_floor():
	#	Player.velocity.y += Player.g.y * delta
	
	if Input.is_action_just_pressed("dash") and Player.canDash:
		return Dashing
	
	if Input.is_action_just_released("jump") and not changedGravity:
		Player.g.y *= Player.fallingGravityScale
		changedGravity = true
	
	direction = Input.get_axis("larrow", "rarrow")
	if direction != 0:
		if Player.speed < Player.max_speed:
			Player.speed += Player.acc * delta
		else:
			Player.speed = Player.max_speed
	else:
		Player.speed = 0

	Player.velocity.x = Player.speed * direction
	
	#print(changedGravity, "	", Player.g, gravityScale)
	return null

func exit() -> State:
	if changedGravity:
		Player.g.y /= Player.fallingGravityScale
		changedGravity = false
	return null
