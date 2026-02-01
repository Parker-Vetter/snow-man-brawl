class_name Ball
extends RigidBody2D

@onready var sprite_2d: Sprite2D = $Sprite2D

var value: float = 1

func get_value() -> float:
	return value

func _ready() -> void:
	var dir: float = 1
	if randf() < 0.5:
		dir = -1
	
	#apply_impulse(Vector2(30 * dir, 0), self.position)

func set_texture(tex: Texture2D):
	await self.ready
	sprite_2d.texture = tex
