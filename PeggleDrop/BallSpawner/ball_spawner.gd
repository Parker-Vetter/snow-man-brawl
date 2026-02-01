extends Node2D

@onready var peggle_drop: PeggleDrop = $".."
@onready var game_data: GameData = peggle_drop.game_data

@onready var line_2d: Line2D = $Line2D
@onready var timer: Timer = $Timer
@onready var ball_holder: Node2D = $BallHolder

@onready var snow: int = game_data.collected_objects.get("snow")
@onready var carrot: int = game_data.collected_objects.get("carrot")
@onready var coal: int = game_data.collected_objects.get("coal")
@onready var stick: int = game_data.collected_objects.get("stick")

var ball = preload("res://PeggleDrop/Ball/ball.tscn")

@onready var snow_sprite: Texture2D = load("res://zacks sprites/ice chunk.png")
@onready var carrot_sprite: Texture2D = load("res://zacks sprites/carrot.png")
@onready var coal_sprite: Texture2D = load("res://zacks sprites/charcol.png")
@onready var stick_sprite: Texture2D = load("res://zacks sprites/stick.png")

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	if timer.is_stopped() and not game_data.collected_objects.is_empty():
		timer.start(0.05)

func _on_timer_timeout() -> void:
	var spawner_location = random_spawn_point()
	game_data.collected_objects.get("snow")
	
	if snow > 0:
		ball_holder.add_child(spawn_new_ball(snow_sprite, spawner_location))
		snow -= 1
	elif carrot > 0:
		ball_holder.add_child(spawn_new_ball(carrot_sprite, spawner_location))
		carrot -= 1
	elif coal > 0:
		ball_holder.add_child(spawn_new_ball(coal_sprite, spawner_location))
		coal -= 1
	elif stick > 0:
		ball_holder.add_child(spawn_new_ball(stick_sprite, spawner_location))
		stick -= 1
	

func spawn_new_ball(sprite: Texture2D, spawner_location: Vector2) -> Ball:
	var new_ball: Ball = ball.instantiate()
	new_ball.set_texture(sprite)
	new_ball.global_position = spawner_location
	return new_ball

func random_spawn_point() -> Vector2:
	var point: Vector2 = line_2d.to_global(line_2d.points[0])
	var point_two: Vector2 = line_2d.to_global(line_2d.points[1])
	var r = randf_range(point.x, point_two.x)
	return Vector2(r, point.y)
