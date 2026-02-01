class_name GameData
extends Resource

## [point] referece to the total points of the player
@export var gold: int

## [game_length] Time for the player to play in the main game scene will be applied to the timer
@export var game_length: float


func add_pickup(id: StringName, amount: int = 1) -> void:
	if not collected_objects.has(id):
		collected_objects[id] = 0

	collected_objects[id] += amount
#@export var collected_objects: Dictionary = {} # { StringName: int }
@export var collected_objects: Dictionary[String, Variant] = {}
