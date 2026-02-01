extends StaticBody2D

@onready var sprite_2d: Sprite2D = $Sprite2D

@onready var animation_tree: AnimationPlayer = $AnimationPlayer


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass


func _on_area_2d_body_entered(body: Node2D) -> void:
	if body is RigidBody2D:
		if not animation_tree.is_playing():
			animation_tree.play("bounce")
