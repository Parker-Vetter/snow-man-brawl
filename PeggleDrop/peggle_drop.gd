class_name PeggleDrop
extends Node

@onready var ball_spawner: Node = $BallSpawner

#const GAME_DATA_PATH := "res://SceneManager/GameData/game_data.tres"
@export var game_data: GameData


func load_game_sate(new_game_data: GameData):
	game_data = new_game_data

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass
