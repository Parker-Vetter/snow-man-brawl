extends Area2D

var dir: float
var spawnPos: Vector2
var spawnRot: float
var spinSpeed: float
var damage: float
var gameData: GameData

func _ready() -> void:
	global_position = spawnPos
	global_rotation = spawnRot
	
func _physics_process(delta: float) -> void:
	var velocity = Vector2(0, gameData.snowball_speed).rotated(dir)
	rotation_degrees += spinSpeed * delta
	position += velocity * delta


func _on_visible_on_screen_notifier_2d_screen_exited():
	queue_free()
	

func _on_body_entered(body: Node2D) -> void:
	if body.is_in_group("enemies"):
		if body.has_method("take_damage"):
			body.take_damage(gameData.snowball_damage)
		queue_free()
