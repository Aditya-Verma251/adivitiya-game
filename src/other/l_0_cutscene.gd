extends Node

func levelZeroCutscene():
	GlobalVariables.isPaused = true
	var script = ["Oh no, oh no, oh no… why is it doing that?", "Okay, okay, deep breath. Let’s fix this… probably.", "Try completing the obstecle course to\n figure out what is going on. \n help "]
	$TextBox.displayText(script)
	PlayerGeneralSignalManager.glitchyPosition.emit()
	await  $TextBox.textDisplayed
	GlobalVariables.isPaused = false
