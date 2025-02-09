extends StaticBody2D

@export var damageValue : int = 1

func _on_area_2d_body_entered(body: Node2D) -> void:
	if body.name == "Player":
		SignalManager.playerDamage.emit(damageValue)
