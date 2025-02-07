extends Node

func levelZeroCutscene():
	GlobalVariables.isPaused = true
	var script = [""]
	$TextBox.displayText(script)
	PlayerGeneralSignalManager.glitchyPosition.emit()
	await  $TextBox.textDisplayed
	GlobalVariables.isPaused = false
