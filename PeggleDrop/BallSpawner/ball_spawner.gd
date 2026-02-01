extends Node2D

@onready var peggle_drop: PeggleDrop = $".."
@onready var game_data: GameData = peggle_drop.game_data

@onready var line_2d: Line2D = $Line2D
@onready var timer: Timer = $Timer
@onready var ball_holder: Node2D = $BallHolder

@onready var snow: int = game_data.get_lifetime_collected_object_count("snow")
@onready var carrot: int = game_data.get_lifetime_collected_object_count("carrot")
@onready var coal: int = game_data.get_lifetime_collected_object_count("coal")
@onready var stick: int = game_data.get_lifetime_collected_object_count("stick")

var ball = preload("res://PeggleDrop/Ball/ball.tscn")

const CARROT = preload("uid://dmgmjn3ut414j")
const CHARCOAL = preload("uid://bkig0oboemrtr")
const SNOW = preload("uid://d11g2i2t70f5q")
const STICK = preload("uid://dbqk4k3mtkryu")

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	if timer.is_stopped() and not game_data.lifetime_collected_objects.is_empty():
		timer.start(0.05)

func _on_timer_timeout() -> void:
	var spawner_location = random_spawn_point()
	
	if snow > 0:
		ball_holder.add_child(spawn_new_ball(SNOW, spawner_location))
		snow -= 1
	elif carrot > 0:
		ball_holder.add_child(spawn_new_ball(CARROT, spawner_location))
		carrot -= 1
	elif coal > 0:
		ball_holder.add_child(spawn_new_ball(CHARCOAL, spawner_location))
		coal -= 1
	elif stick > 0:
		ball_holder.add_child(spawn_new_ball(STICK, spawner_location))
		stick -= 1
	

func spawn_new_ball(data:PickupData, spawner_location: Vector2) -> Ball:
	var new_ball: Ball = ball.instantiate()
	new_ball.set_texture(data.sprite)
	new_ball.value = data.value
	new_ball.global_position = spawner_location
	return new_ball

func random_spawn_point() -> Vector2:
	var point: Vector2 = line_2d.to_global(line_2d.points[0])
	var point_two: Vector2 = line_2d.to_global(line_2d.points[1])
	var r = randf_range(point.x, point_two.x)
	return Vector2(r, point.y)
