extends Area2D
class_name Pickup

@export var data: PickupData
@onready var sprite := $Sprite2D

var dir: float
var spawnPos: Vector2
var spawnRot: float
var spinSpeed: float
var speed:float

func _ready() -> void:
	sprite.texture = data.sprite
	global_position = spawnPos
	global_rotation = spawnRot
	
func _physics_process(delta: float) -> void:
	var velocity = Vector2(0, speed).rotated(dir)
	rotation_degrees += spinSpeed * delta
	position += velocity * delta


func _on_visible_on_screen_notifier_2d_screen_exited():
	queue_free()

func pickup(gameData: GameData):
	gameData.add_pickup(data.id)
	queue_free()
