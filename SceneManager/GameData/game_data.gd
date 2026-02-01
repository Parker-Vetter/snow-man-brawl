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

@export var collected_objects: Dictionary[String, Variant] = {}

## Multipliers for each slot in the pachinco machine
@export var pachinko_multipliers: Array[int] = [1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1]

## Snowballs per second for the main snowball throw
@export var throw_rate: int = 0.5

## Damage of the main snowball
@export var snowball_damage: int = 1;

## Speed of the main snowball
@export var snowball_speed: float = 150.0;

## Move speed of the player
@export var player_move_speed: float = 100.0;

## Snowment per second spawn rate
@export var snowman_spawn_rate: float = 1.0;

## How many levels of the auto backpack are unlocked 0 - 4
@export var unlock_auto_backpack: int = 0;

## Snowballs per second for the auto backpack
@export var auto_backpack_fire_rate: float = 0.5;
