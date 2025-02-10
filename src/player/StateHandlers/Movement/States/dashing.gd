extends State

var Player : Player
var Anim : AnimatedSprite2D
@export var Idle : State
@export var Running : State
@export var Falling : State

var endDash : bool = false
var og

func init(p, a):
	Player = p
	Anim = a

func enter():
	og = Player.g
	if Player.canDash and Player.DashTimer.is_stopped():
		Player.velocity.x = Player.dashSpeed * Player.Facing.position.x
		#Player.velocity.y = 0
		Player.DashTime.start()
		Player.DashTimer.start()
		Player.canDash = false
	else:
		endDash = true

func state_physics_process(delta:float) -> State:
	if endDash:
		endDash = false
		return Running
	elif Player.velocity.y != 0 or Player.g.y != 0:
		Player.g.y = 0
		Player.velocity.y = 0
	
	return null

func exit():
	Player.g = og

func _on_dash_time_timeout() -> void:
	endDash = true
