extends Button

var scene_manager: SceneManager
var peggle_drop: Node2D

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	scene_manager = get_tree().get_nodes_in_group("SceneManager")[0]
	peggle_drop = get_tree().get_nodes_in_group("PeggleDrop")[0]


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass


func _on_pressed() -> void:
	var gd = peggle_drop.game_data
	scene_manager.switch_scene(peggle_drop, "res://MainGame/Scenes/mainGame.tscn", gd)
