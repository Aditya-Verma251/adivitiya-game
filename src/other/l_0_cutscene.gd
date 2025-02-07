extends Node

func levelZeroCutscene():
	GlobalVariables.isPaused = true
	var script = ["ummmm \n it seems you are movement is gliching", "i will have to fix that ;^;", "Try completing the level so i get to known\n what's wrong \n help "]
	$TextBox.displayText(script)
	PlayerGeneralSignalManager.glitchyPosition.emit()
	await  $TextBox.textDisplayed
	GlobalVariables.isPaused = false
