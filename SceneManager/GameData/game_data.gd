class_name GameData
extends Resource

## [point] referece to the total points of the player
@export var gold: int


@export var level = 1;
@export var kills = 0;
@export var snow_balls_thrown = 0;
@export var lifetime_pickup = 0;
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
@export var pachinko_multiplier: Array[int] = [1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1]
@export var pachinko_multiplier_upgrade_level: int = 0;
@export var pachinko_multiplier_upgrade_costs: Array[int] = [1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 4, 4, 4, 4, 4, 4, 4, 4, 4, 4, 4, 8, 8, 8, 8, 8, 8, 8, 8, 8, 8, 8, 16, 16, 16, 16, 16, 16, 16, 16, 16, 16, 16, 32, 32, 32, 32, 32, 32, 32, 32, 32, 32, 32, 64, 64, 64, 64, 64, 64, 64, 64, 64, 64, 64, 128, 128, 128, 128, 128, 128, 128, 128, 128, 128, 128, 256, 256, 256, 256, 256, 256, 256, 256, 256, 256, 256, 512, 512, 512, 512, 512, 512, 512, 512, 512, 512, 512]
## Snowballs per second for the main snowball throw
@export var throw_rate_upgrades: Array[float] = [1, 1.5, 2.5, 5, 8]
@export var throw_rate_upgrade_costs: Array[int] = [1, 10, 100, 1500]
@export var throw_rate_upgrade_level: int = 0;
var throw_rate: float:
	get:
		return throw_rate_upgrades[throw_rate_upgrade_level]

## Damage of the main snowball
@export var snowball_damage_upgrades: Array[int] = [1, 2, 3, 4, 5]
@export var snowball_damage_upgrade_costs: Array[int] = [1, 10, 100, 1500]
@export var snowball_damage_upgrade_level: int = 0;
var snowball_damage: int:
	get:
		return snowball_damage_upgrades[snowball_damage_upgrade_level]

## Speed of the main snowball
@export var snowball_speed_upgrades: Array[float] = [150.0, 175.0, 200.0, 225.0, 250.0]
@export var snowball_speed_upgrade_costs: Array[int] = [1, 10, 100, 1500]
@export var snowball_speed_upgrade_level: int = 0;
var snowball_speed: float:
	get:
		return snowball_speed_upgrades[snowball_speed_upgrade_level]

## Move speed of the player
@export var player_move_speed_upgrades: Array[float] = [100.0, 125.0, 150.0, 175.0, 200.0]
@export var player_move_speed_upgrade_costs: Array[int] = [1, 10, 100, 1500]
@export var player_move_speed_upgrade_level: int = 0;
var player_move_speed: float:
	get:
		return player_move_speed_upgrades[player_move_speed_upgrade_level]

## Snowment per second spawn rate
@export var snowman_spawn_rate_upgrades: Array[float] = [1.0, 1.25, 1.5, 1.75, 2.0]
@export var snowman_spawn_rate_upgrade_costs: Array[int] = [1, 10, 100, 1500]
@export var snowman_spawn_rate_upgrade_level: int = 0;
var snowman_spawn_rate: float:
	get:
		return snowman_spawn_rate_upgrades[snowman_spawn_rate_upgrade_level]

@export var auto_backpack_upgrades: Array[int] = [0, 1, 2, 3, 4]
@export var auto_backpack_upgrade_level: int = 0;
@export var auto_backpack_upgrade_costs: Array[int] = [10, 100, 1500]
var auto_backpack: int:
	get:
		return auto_backpack_upgrades[auto_backpack_upgrade_level]

## Snowballs per second for the auto backpack
@export var auto_backpack_fire_rate_upgrades: Array[float] = [0.5, 0.75, 1.0, 1.25, 1.5]
@export var auto_backpack_fire_rate_upgrade_costs: Array[int] = [15, 30, 60, 120, 240]
@export var auto_backpack_fire_rate_upgrade_level: int = 0;
var auto_backpack_fire_rate: float:
	get:
		return auto_backpack_fire_rate_upgrades[auto_backpack_fire_rate_upgrade_level]


## Game Time Upgrades
@export var game_length_upgrades: Array[float] = [15.0, 30.0, 60.0, 120.0, 240.0, 480.0]
@export var game_length_upgrade_costs: Array[int] = [10, 30, 100, 300, 1000]
@export var game_length_upgrade_level: int = 0;
var game_length: float:
	get:
		return game_length_upgrades[game_length_upgrade_level]
