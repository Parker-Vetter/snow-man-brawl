extends CharacterBody2D


@export var speed: float = 100
var dir :float
var spawnPos : Vector2
var spawnRot : float
var spinSpeed: float

func _ready() -> void:
	global_position = spawnPos
	global_rotation = spawnRot
	
func _physics_process(delta: float) -> void:
	velocity = Vector2(0, speed).rotated(dir)
	rotation_degrees += spinSpeed * delta
	move_and_slide()

func _on_visible_on_screen_notifier_2d_screen_exited():
	queue_free()
	
