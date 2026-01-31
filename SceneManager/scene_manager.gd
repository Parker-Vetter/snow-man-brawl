class_name SceneManager
extends Node

@onready var switch_node: Node = $SwitchNode

## Pass in the old scene(self) and the new scene that we want example of new_scene = "res://2DRTS/2D_RTS.tscn"
func switch_scene(old_loaded_scene: Node, new_scene: String, game_data: GameData):
	old_loaded_scene.queue_free()
	var main_scene = load(new_scene).instantiate()
	switch_node.add_child.call_deferred(main_scene)
	await main_scene.ready
	if main_scene.has_method("load_game_data") && game_data != null:
		main_scene.load_game_state(game_data)
