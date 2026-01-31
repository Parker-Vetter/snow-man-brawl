extends Marker2D
@onready var timer:Timer = $Timer

## The list of enemies to spawn
@export var enemies: Resource
## How many enemies to spawn
@export var initialSpawnCount = 4
## Time in seconds between spawns
@export var spawnDelay = 5


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	timer.wait_time = spawnDelay
	timer.start()


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass


func _on_timer_timeout() -> void:
	print("SPAWN")
