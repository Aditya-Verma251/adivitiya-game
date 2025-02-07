extends Node

func levelZeroCutscene():
	GlobalVariables.isPaused = true
	var script = ["meow", "woof"]
	$TextBox.displayText(script)
	PlayerGeneralSignalManager.glitchyPosition.emit()
	await  $TextBox.textDisplayed
	GlobalVariables.isPaused = false
