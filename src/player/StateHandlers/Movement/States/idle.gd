extends State

var Player : Player
var Anim : AnimatedSprite2D
@export var Falling : State
@export var Running : State
@export var Jumping : State
@export var Dashing : State

var direction
var coyoteTimeEnd : bool = false

func init(p, a):
	Player = p
	Anim = a

func enter():
	print("idle")
	if Anim.is_playing():
		Anim.stop()
	
	Anim.animation = "idle"
	Anim.play()
	
	Player.velocity = Vector2.ZERO

func state_physics_process(delta:float) -> State:
	if (Player.is_on_floor() or not Player.CoyoteTimer.is_stopped()) and Input.is_action_just_pressed("jump"):
		print("jumpong")
		return Jumping

	if not Player.is_on_floor():
		if Player.coyoteTimeEnd:
			Player.coyoteTimeEnd = false
			return Falling
		elif Player.CoyoteTimer.is_stopped():
			Player.CoyoteTimer.start()

	direction = Input.get_axis("larrow", "rarrow")
	if direction != 0:
		print("running")
		return Running

	if Input.is_action_just_pressed("dash") and Player.canDash:
		return Dashing

	return null

func exit() -> State:
	print("not idle")
	return null
