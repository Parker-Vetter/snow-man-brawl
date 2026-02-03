extends Area2D

var dir: float
var spawnPos: Vector2
var spawnRot: float
var spinSpeed: float
var damage: float
var gameData: GameData
var main: MainGame
@onready var impact = load("res://MainGame/Scenes/Impact.tscn")
@onready var snow_dust: CPUParticles2D = $SnowDust
@onready var trail: Line2D = $Trail

@export var trail_length := 15

func _ready() -> void:
	global_position = spawnPos
	global_rotation = spawnRot
	snow_dust.direction = Vector2(0, -1).rotated(dir)

	# Scale effects based on snowball speed upgrade
	var max_level = gameData.snowball_speed_upgrades.size() - 1
	var upgrade_ratio = float(gameData.snowball_speed_upgrade_level) / float(max_level)
	trail_length = int(lerpf(13.0, 27.0, upgrade_ratio))
	snow_dust.scale = Vector2.ONE * lerpf(1.0, 7.0, upgrade_ratio)
	
func _physics_process(delta: float) -> void:
	var velocity = Vector2(0, gameData.snowball_speed).rotated(dir)
	rotation_degrees += spinSpeed * delta
	position += velocity * delta
	snow_dust.global_position = global_position

	# Matrix-style trail
	trail.add_point(global_position)
	if trail.get_point_count() > trail_length:
		trail.remove_point(0)


func _on_visible_on_screen_notifier_2d_screen_exited():
	trail.clear_points()
	queue_free()
	

func _on_body_entered(body: Node2D) -> void:
	if body.is_in_group("enemies"):
		var instance = impact.instantiate()
		instance.global_position = global_position
		instance.rotation = rotation
		main.add_child.call_deferred(instance)

		if body.has_method("take_damage"):
			body.take_damage(gameData.snowball_damage)
		trail.clear_points()
		queue_free()
