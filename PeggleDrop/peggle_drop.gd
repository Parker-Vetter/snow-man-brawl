class_name PeggleDrop
extends Node

@onready var ball_spawner: Node = $BallSpawner
@onready var ball_holder: Node = $BallHolder

#const GAME_DATA_PATH := "res://SceneManager/GameData/game_data.tres"
@export var game_data: GameData

func _ready() -> void:
	game_data.point = 1
	print(str(game_data.point))


func load_game_sate(new_game_data: GameData):
	game_data = new_game_data

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass
