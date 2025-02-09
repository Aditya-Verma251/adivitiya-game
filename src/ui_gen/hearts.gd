extends CanvasLayer

func health_display(heart:int):

	if heart<=2:
		$HBoxContainer/TextureRect.visible=false

	if heart<=1:
		$HBoxContainer/TextureRect2.visible=false
		
	if heart<=0:
		$HBoxContainer/TextureRect3.visible=false
