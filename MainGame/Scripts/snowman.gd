extends CharacterBody2D


@export var maxHealth: float = 3
@export var speed: float = 100


var player
var dir: float
var spawnPos: Vector2
var spawnRot: float
var spinSpeed: float
var gameData: GameData
@onready var health: float = maxHealth

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

func take_damage(damage: float) -> void:
	health -= damage
	if health <= 0:
		gameData.collected_objects["snowman"] = 1
		queue_free()
