extends State

var Player : Player
var Anim : AnimatedSprite2D
@export var Idle : State
@export var Falling : State
@export var Jumping : State
@export var Dashing : State

var direction
var coyoteTimeEnd : bool = false

func init(p, a):
	Player = p
	Anim = a

func enter():
	if Anim.is_playing():
		Anim.stop()
	
	Anim.animation = "run"
	Anim.play()

func state_physics_process(delta:float) -> State:
	if (Player.is_on_floor() or not Player.CoyoteTimer.is_stopped()) and Input.is_action_just_pressed("jump"):
		print("jumpong")
		return Jumping

	if not Player.is_on_floor():
		if Player.coyoteTimeEnd:
			Player.coyoteTimeEnd = false
			return Falling
		elif Player.CoyoteTimer.is_stopped():
			print("started")
			Player.CoyoteTimer.start()

	if Input.is_action_just_pressed("dash") and Player.canDash:
		return Dashing

	direction = Input.get_axis("larrow", "rarrow")
	if direction != 0:
		if Player.speed < Player.max_speed:
			Player.speed += Player.acc * delta
		else:
			Player.speed = Player.max_speed
	else:
		Player.speed = 0
		Player.velocity.x = Player.speed * direction
		return Idle

	Player.velocity.x = Player.speed * direction
	return null

func exit() -> State:
	return null
