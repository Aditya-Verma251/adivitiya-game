extends Node

var Player
var Anim
@export var inital_state : State
var current_state : State
var new_state : State

func change_state(nState : State):
	current_state = nState

func init(p, a):
	Player = p
	Anim = a
	$Idle.init(Player, Anim)
	$Running.init(Player, Anim)
	$Jumping.init(Player, Anim)
	$Dashing.init(Player, Anim)
	$Falling.init(Player, Anim)

func _ready() -> void:
	current_state = inital_state
	

func _process(delta: float) -> void:
	new_state = current_state.state_process(delta)

	if new_state != null:
		current_state.exit()
		change_state(new_state)
		current_state.enter()
		new_state = null

func _physics_process(delta: float) -> void:
	new_state = current_state.state_physics_process(delta)

	if new_state != null:
		print(current_state)
		current_state.exit()
		print(new_state)
		change_state(new_state)
		current_state.enter()
		new_state = null
