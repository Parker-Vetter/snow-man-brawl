class_name MainGame
extends Node2D
@export var gameData: GameData
@onready var scene_manager: SceneManager = get_tree().get_nodes_in_group("SceneManager")[0]
#@onready var peggle_drop: Node2D = get_tree().get_nodes_in_group("PeggleDrop")[0]


func load_game_state(new_game_data: GameData):
	gameData = new_game_data


func switchToPeggleDrop():
	scene_manager.switch_scene(self, "res://PeggleDrop/PeggleDrop.tscn", gameData)
	pass
