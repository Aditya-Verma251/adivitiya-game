extends RichTextLabel

signal lineWritten

@export var animationSpeed : float
var toWrite = "new"
var isFinished : bool = false

func _ready() -> void:
	visible_ratio = 0

func _process(delta: float) -> void:
	if not isFinished:
		#print("is not finished")
		if visible_ratio < 1:
			#print("is not visible")
#			text = toWrite
			visible_ratio += (1.0/text.length()) * (animationSpeed * delta)
		else:
			#print("isVisible")
			isFinished = true
	else:
		#print("is finished")
		lineWritten.emit()
	
	if Input.is_action_just_pressed("confirm"):
		visible_ratio = 1

func write(line):
	visible_ratio = 0
	toWrite = line
	text = toWrite
	isFinished = false
