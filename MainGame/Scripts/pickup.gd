extends Area2D
class_name Pickup

@export var data: PickupData
@onready var sprite := $Sprite2D
@onready var collision_shape := $CollisionShape2D
@onready var audio_stream_player: AudioStreamPlayer = $AudioStreamPlayer

var dir: float
var spawnPos: Vector2
var spawnRot: float
var spinSpeed: float
var speed: float
var is_collecting: bool = false

func _ready() -> void:
	sprite.texture = data.sprite
	global_position = spawnPos
	global_rotation = spawnRot
	
func _physics_process(delta: float) -> void:
	if is_collecting:
		return # Don't move during collection animation
	var velocity = Vector2(0, speed).rotated(dir)
	rotation_degrees += spinSpeed * delta
	position += velocity * delta


func _on_visible_on_screen_notifier_2d_screen_exited():
	queue_free()

func pickup(player: Player):
	if is_collecting:
		return # Already collecting
	audio_stream_player.play()
	is_collecting = true
	# Disable collision
	collision_shape.set_deferred("disabled", true)
	
	# Stop physics movement
	speed = 0
	spinSpeed = 0
	
	# Create tween for smooth animation
	var tween = create_tween()
	tween.set_parallel(true)
	
	var target_pos = player.global_position
	tween.tween_property(self, "global_position", target_pos, 0.75) \
		.set_ease(Tween.EASE_IN).set_trans(Tween.TRANS_BACK)
	
	var start_scale = sprite.scale
	tween.tween_property(sprite, "scale", start_scale * 1.2, 0.25)
	tween.tween_property(sprite, "scale", Vector2.ZERO, 0.5).set_delay(0.25)
	
	await tween.finished
	player.main.gameData.add_pickup(data.id)
	player.main.gameData.lifetime_pickup += 1
	queue_free()
