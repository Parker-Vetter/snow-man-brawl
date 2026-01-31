extends Node

## Pass in the old scene(self) and the new scene that we want example of new_scene = "res://2DRTS/2D_RTS.tscn"
func switch_scene(old_loaded_scene: Node, new_scene: String):
	old_loaded_scene.queue_free()
	var main_scene = load(new_scene).instantiate()
	self.add_child.call_deferred(main_scene)
	await main_scene.ready
