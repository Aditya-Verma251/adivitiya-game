extends Node2D

var player
var triggered = GlobalVariables.isTriggered
@export var opos : Node2D

func glitchCutscene() -> void:
	pass

func _ready() -> void:
	#Input.set_mouse_mode(Input.MOUSE_MODE_HIDDEN)
	player = SceneHolder.player
	var p = player.instantiate()
	
	if CheckPointHolder.exists:
		p.position = CheckPointHolder.getCheckpoint()
	else:
		p.position = opos.position
	
	add_child(p)
	

func _on_glitch_trigger_body_entered(body: Node2D) -> void:
	if not triggered:
		triggered = true
		GlobalVariables.isTriggered = true
		if body.name == "Player":
			glitchCutscene()
	pass # Replace with function body.


func _on_area_2d_body_entered(body: Node2D) -> void:
	if not triggered:
		triggered = true
		GlobalVariables.isTriggered = true
		if body.name == "Player":
			$cutscenetrigger/L0Cutscene.levelZeroCutscene() # Replace with function body.
