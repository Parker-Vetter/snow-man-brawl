extends CharacterBody2D

@onready var pickupScene = load("res://MainGame/Scenes/pickup.tscn")
@onready var standard_sprite: AnimatedSprite2D = $StandardSprite
@onready var ski_mask_sprite: AnimatedSprite2D = $SkiMaskSprite
@onready var splat: AudioStreamPlayer = $Splat

@export var maxHealth: int = 2
@export var scaleHealthByLevel = true;
@export var speed: float = 100
@export var drop_table: Array[DropTableEntry] = []
@export var number_of_drops: int = 1
@export var scaleDropsByLevel = true

var player: CharacterBody2D
var main: MainGame
var dir: float
var spawnPos: Vector2
var spawnRot: float
var spinSpeed: float
var gameData: GameData
var _internal_drop_table: Array[int] = []

var health: int

func _ready() -> void:
	if not player:
		print("Player not found")
		return
	global_position = spawnPos
	global_rotation = spawnRot
	health = maxHealth * (main.gameData.level if scaleHealthByLevel else 1)
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
	

func take_damage(damage: int) -> void:
	health -= damage
	#splat.play()
	if health <= 0:
		var drops = number_of_drops * (main.gameData.level if scaleDropsByLevel else 1)
		for i in range(number_of_drops):
			var drop = drop_table[_internal_drop_table.pick_random()]
			var pickup = pickupScene.instantiate()
			pickup.data = drop.data
			var floatAngle = randf_range(-PI, PI)
			pickup.dir = floatAngle
			pickup.spawnPos = position + Vector2(randi_range(-50, 50), randi_range(-50, 50))
			pickup.spawnRot = floatAngle
			pickup.spinSpeed = randf_range(-300, 300)
			pickup.speed = randf_range(-50, 50)
			main.add_child.call_deferred(pickup)
		queue_free()
