extends CanvasLayer

func _ready() -> void:
	$TextBoxContainer.visible = false

func  displayText(text):
	$TextBoxContainer.visible = true
	
	for line in text:
		#print("written")
		$TextBoxContainer/LowerHalf/ColorRect/MarginContainer/Control/DialogueText.write(line)
		await  $TextBoxContainer/LowerHalf/ColorRect/MarginContainer/Control/DialogueText.lineWritten
		$Timer.start()
		await  $Timer.timeout
	
	$PlayerFinalAcceptHandler.listen()
	await $PlayerFinalAcceptHandler.playerFinalAccept
	$TextBoxContainer.visible = false
