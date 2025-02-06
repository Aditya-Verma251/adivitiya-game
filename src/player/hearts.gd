extends CanvasLayer


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass

func health_display(heart:int):

	if heart<=2:
		$HBoxContainer/TextureRect.visible=false

	if heart<=1:
		$HBoxContainer/TextureRect2.visible=false
		
	if heart<=0:
		$HBoxContainer/TextureRect3.visible=false
