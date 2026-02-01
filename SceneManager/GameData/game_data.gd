class_name GameData
extends Resource

## [point] referece to the total points of the player
@export var gold: int

## [game_length] Time for the player to play in the main game scene will be applied to the timer
@export var game_length: float


@export var level = 1;
@export var resources_needed_to_progress = 10;
@export var resources_collected_this_level = 0;
@export var ready_for_level_transition = false;


func add_pickup(id: StringName, amount: int = 1) -> void:
	if not collected_objects.has(id):
		collected_objects[id] = 0

	collected_objects[id] += amount
	resources_collected_this_level += amount
	if resources_collected_this_level >= level * 10:
		ready_for_level_transition = true

func start_level():
	resources_collected_this_level = 0
	ready_for_level_transition = false
	resources_needed_to_progress = level * 10
	
func next_level():
	level += 1


@export var collected_objects: Dictionary[String, Variant] = {}

## Multipliers for each slot in the pachinco machine
@export var pachinko_multipliers: Array[int] = [1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1]

## Snowballs per second for the main snowball throw
@export var throw_rate: float = 0.5

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
