extends Node2D

func  _ready() -> void:
	$Player/Camera2D.limit_bottom = 9999999
	$Player/Camera2D.limit_top = -9999999
	$Player/Camera2D.limit_left = -9999999
	$Player/Camera2D.limit_right = 9999999

func _on_area_2d_body_entered(body: Node2D) -> void:
	if body.name == "Player":
		var m = ["player has entered"]
		$TextBox.displayText(m) # Replace with function body.


func _on_area_2d_body_exited(body: Node2D) -> void:
	if body.name == "Player":
		var q = ["lorem fjalsdkf oapfkap rokewpkr e", "jdopfjweofe op p\n op po pkopfdp dsf  fsdsdfdsf dfsd fdsf sdf dsfdsf  dfsfsd dssfsf dsfsdfds fsdf dfsdfs ", "jweoifj ijqw o joqijo jie ojidf oj"]
		$TextBox.displayText(q)
