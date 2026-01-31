extends Control
@onready var scene_manager: SceneManager = get_tree().get_first_node_in_group("SceneManager")


func switchToPeggleDrop():
	scene_manager.switch_scene(self, "res://PeggleDrop/PeggleDrop.tscn")
	pass


func _on_play_pressed() -> void:
	switchToPeggleDrop()
