extends Sprite2D

var vel = Vector2.ZERO
@export var e2 = "meow"
@export var damageValue : int = 5
# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	position += vel * delta
	
func move(dir:Vector2):
	vel = dir

func setException(v):
	e2 = v

func _on_enemy_2_projectile_body_entered(body: Node2D) -> void:
	#print(e2)
	if body.name == "Player":
		PlayerDamageController.playerDamage.emit(damageValue)
	if body.name != e2:
		queue_free()


func _on_destroy() -> void:
	queue_free() # Replace with function body.
