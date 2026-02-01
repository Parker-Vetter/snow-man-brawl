extends Control
@onready var scene_manager: SceneManager = get_tree().get_first_node_in_group("SceneManager")


func startGame():
	scene_manager.switch_scene(self, "res://MainGame/Scenes/mainGame.tscn")
	pass


func _on_play_pressed() -> void:
	startGame()
