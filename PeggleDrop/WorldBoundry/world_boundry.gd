extends Area2D
@onready var peggle_drop: PeggleDrop = $".."


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass

func _on_body_entered(body: Node2D) -> void:
	if body is RigidBody2D:
		peggle_drop.game_data.gold += body.get_value()
		body.queue_free()
