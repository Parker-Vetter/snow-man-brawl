extends Marker2D
@onready var timer: Timer = $EnemySpawnTimer
@onready var main: Node2D = $".."
@onready var player: CharacterBody2D = $"../Player"

## The list of enemies to spawn
@export var enemies: Array[Resource]
## How many enemies to spawn
@export var initialSpawnCount = 4
## Time in seconds between spawns
@export var spawnDelay = 5


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	timer.wait_time = spawnDelay
	timer.start()
	for _i in initialSpawnCount:
		spawn()


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta: float) -> void:
	pass

func _on_timer_timeout() -> void:
	spawn()

func getRandomPositionOffScreen(margin: float = 100) -> Vector2:
	var viewport: Rect2 = get_viewport_rect()
	var spawnRect = viewport.grow(margin)
	
	# Pick a random side (0=top, 1=right, 2=bottom, 3=left)
	var side = randi() % 4
	var pos: Vector2
	
	match side:
		0: # Top edge
			pos = Vector2(
				randf_range(spawnRect.position.x, spawnRect.position.x + spawnRect.size.x),
				spawnRect.position.y
			)
		1: # Right edge
			pos = Vector2(
				spawnRect.position.x + spawnRect.size.x,
				randf_range(spawnRect.position.y, spawnRect.position.y + spawnRect.size.y)
			)
		2: # Bottom edge
			pos = Vector2(
				randf_range(spawnRect.position.x, spawnRect.position.x + spawnRect.size.x),
				spawnRect.position.y + spawnRect.size.y
			)
		3: # Left edge
			pos = Vector2(
				spawnRect.position.x,
				randf_range(spawnRect.position.y, spawnRect.position.y + spawnRect.size.y)
			)
	return pos


func spawn():
	var e = enemies.pick_random()
	var instance = e.instantiate()
	instance.dir = rotation - PI / 2
	instance.spawnPos = getRandomPositionOffScreen()
	instance.spinSpeed = randf_range(-300, 300)
	instance.gameData = main.gameData
	instance.player = player
	instance.main = main
	main.add_child.call_deferred(instance)
