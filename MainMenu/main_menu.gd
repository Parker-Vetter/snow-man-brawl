extends Control
@onready var scene_manager: SceneManager = get_tree().get_first_node_in_group("SceneManager")
@export var game_data:GameData;

#Prepare Nodes I want visible and invisible
@onready var credittext:Node = $VBoxContainer2/VBoxContainer/HBoxContainer2/Button/Label
@onready var backtext:Node = $VBoxContainer2/VBoxContainer/HBoxContainer2/Button/Back
@onready var credits: Node = $Credits
@onready var spthank : Node = $Spthanks
func startGame():
	scene_manager.switch_scene(self, "res://MainGame/Scenes/mainGame.tscn", game_data)
	#scene_manager.switch_scene(self, "res://PeggleDrop/PeggleDrop.tscn", game_data)
	pass


func _on_play_pressed() -> void:
	startGame()

#When credit button is pressed, swap visibility of credits and special thanks. Default visibility is not visible.
func _on_button_pressed() -> void:
	credittext.visible = !credittext.visible
	backtext.visible = !backtext.visible
	credits.visible = !credits.visible
	spthank.visible = !spthank.visible
	
