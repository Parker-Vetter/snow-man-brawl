class_name MainGame
extends Node2D
@export var gameData: GameData
@onready var scene_manager: SceneManager = get_tree().get_nodes_in_group("SceneManager")[0]
#@onready var peggle_drop: Node2D = get_tree().get_nodes_in_group("PeggleDrop")[0]
@onready var death: Panel = $CanvasLayer/MainUI/Death


func load_game_state(new_game_data: GameData):
	gameData = new_game_data
	gameData.collected_objects = {}
	gameData.start_level()

func pause_and_death_menu():
	death.visible = true
	get_tree().paused = not get_tree().paused

func switchToPeggleDrop():
	scene_manager.switch_scene(self, "res://PeggleDrop/PeggleDrop.tscn", gameData)

func retryLevel():
	scene_manager.switch_scene(self, "res://MainGame/Scenes/mainGame.tscn", gameData)

func nextLevel():
	gameData.next_level()
	scene_manager.switch_scene(self, "res://MainGame/Scenes/mainGame.tscn", gameData)
