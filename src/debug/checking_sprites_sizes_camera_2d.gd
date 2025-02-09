extends Camera2D

@export var zs : float = 1

func _process(delta: float) -> void:
	var z : float
	z = 0
	var x
	if Input.is_mouse_button_pressed(MOUSE_BUTTON_WHEEL_DOWN) or Input:
		z = -1
		x = true
	elif Input.is_mouse_button_pressed(MOUSE_BUTTON_WHEEL_UP):
		z = 1
		x = true
	
	if not x:
		if Input.is_action_just_released("scrollup"):
			z = 1
		elif Input.is_action_just_released("scrolldown"):
			z = -1
		#z = Input.get_axis("scrolldown", "scrollup")
	
	var q = zoom.x
	q += ((z * zs * delta) / zoom.x)
	
	zoom = Vector2(clamp(q, 10, 0.01), clamp(q, 10, 0.01))
	position += InputEventMouseMotion.new().velocity * delta * 0.1
