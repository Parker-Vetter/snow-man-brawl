class_name PeggleDrop
extends Node

@onready var ball_spawner: Node = $BallSpawner
@onready var upgrades_panel: Control = $CanvasLayer/UpgradesPanel


#const GAME_DATA_PATH := "res://SceneManager/GameData/game_data.tres"
@export var game_data: GameData

func _ready() -> void:
	upgrades_panel.visible = false

func load_game_state(new_game_data: GameData):
	game_data = new_game_data
	var nodes = find_children("Multilpyer*")
	for n in nodes:
		n.gameData = new_game_data

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass


func _on_upgrades_button_pressed() -> void:
	upgrades_panel.visible = true


func _on_close_upgrades_button_pressed() -> void:
	upgrades_panel.visible = false
