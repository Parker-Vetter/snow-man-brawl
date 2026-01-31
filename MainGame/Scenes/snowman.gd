extends CharacterBody2D

@onready var player = get_tree().get_root().get_node("MainGame").get_node("Player")

@export var speed: float = 100
var dir: float
var spawnPos: Vector2
var spawnRot: float
var spinSpeed: float

func _ready() -> void:
	add_to_group("enemies")
	if not player:
		print("Player not found")
		return
	global_position = spawnPos
	global_rotation = spawnRot
	
func _physics_process(_delta: float) -> void:
	if not player:
		return
	var direction = global_position.direction_to(player.global_position)
	velocity = direction * speed
	move_and_slide()
