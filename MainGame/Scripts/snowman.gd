extends CharacterBody2D

@onready var pickupScene = load("res://MainGame/Scenes/pickup.tscn")

@export var maxHealth: float = 3
@export var speed: float = 100
@export var drop_table: Array[DropTableEntry] = []
@export var number_of_drops: int = 1

var player: CharacterBody2D
var main: Node2D
var dir: float
var spawnPos: Vector2
var spawnRot: float
var spinSpeed: float
var gameData: GameData
var _internal_drop_table: Array[int] = []

@onready var health: float = maxHealth

func _ready() -> void:
	if not player:
		print("Player not found")
		return
	global_position = spawnPos
	global_rotation = spawnRot
	_internal_drop_table = []
	for i in range(drop_table.size()):
		for j in range(drop_table[i].chance * 100):
			_internal_drop_table.append(i)
	
func _physics_process(_delta: float) -> void:
	if not player:
		return
	var direction = global_position.direction_to(player.global_position)
	velocity = direction * speed
	move_and_slide()
	

func take_damage(damage: float) -> void:
	health -= damage
	if health <= 0:
		for i in range(number_of_drops):
			var drop = drop_table[_internal_drop_table.pick_random()]
			var pickup = pickupScene.instantiate()
			pickup.data = drop.data
			var floatAngle = randf_range(-PI, PI)
			pickup.dir = floatAngle
			pickup.spawnPos = position+Vector2(randi_range(-50, 50), randi_range(-50, 50))
			pickup.spawnRot = floatAngle
			pickup.spinSpeed = randf_range(-300, 300)
			pickup.speed = randf_range(-50, 50)
			main.add_child.call_deferred(pickup)
		queue_free()
