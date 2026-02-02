class_name GameData
extends Resource

signal gold_changed(new_amount)

## [point] referece to the total points of the player
@export var gold: int:
	set(value):
		gold = value
		gold_changed.emit(gold)

@export var level = 1;
@export var kills = 0;
@export var snow_balls_thrown = 0;
@export var lifetime_pickup = 0;
@export var rounds_played = 0;
@export var resources_needed_to_progress = 10;
@export var resources_collected_this_level = 0;
@export var ready_for_level_transition = false;


func add_pickup(id: StringName, amount: int = 1) -> void:
	if not collected_objects.has(id):
		collected_objects[id] = 0
	if not lifetime_collected_objects.has(id):
		lifetime_collected_objects[id] = 0

	collected_objects[id] += amount
	lifetime_collected_objects[id] += amount
	resources_collected_this_level += amount
	lifetime_pickup = + amount
	if resources_collected_this_level >= level * 10:
		ready_for_level_transition = true

func start_level():
	resources_collected_this_level = 0
	ready_for_level_transition = false
	resources_needed_to_progress = level * 10
	
func next_level():
	level += 1

func getUpgradePercentage() -> float:
	var possible_upgrades = 0
	possible_upgrades += throw_rate_upgrades.size()
	possible_upgrades += snowball_damage_upgrades.size()
	possible_upgrades += snowball_speed_upgrades.size()
	possible_upgrades += player_move_speed_upgrades.size()
	possible_upgrades += snowman_spawn_rate_upgrades.size()
	possible_upgrades += auto_backpack_upgrades.size()
	possible_upgrades += auto_backpack_fire_rate_upgrades.size()
	possible_upgrades += game_length_upgrades.size()

	var actual_upgrades = 0
	actual_upgrades += throw_rate_upgrade_level
	actual_upgrades += snowball_damage_upgrade_level
	actual_upgrades += snowball_speed_upgrade_level
	actual_upgrades += player_move_speed_upgrade_level
	actual_upgrades += snowman_spawn_rate_upgrade_level
	actual_upgrades += auto_backpack_upgrade_level
	actual_upgrades += auto_backpack_fire_rate_upgrade_level
	actual_upgrades += game_length_upgrade_level

	return float(actual_upgrades) / float(possible_upgrades)

@export var lifetime_collected_objects: Dictionary[String, Variant] = {}
@export var collected_objects: Dictionary[String, Variant] = {}
func get_collected_object_count(id: StringName) -> int:
	return collected_objects.get(id) if collected_objects.has(id) else 0
func get_lifetime_collected_object_count(id: StringName) -> int:
	return lifetime_collected_objects.get(id) if lifetime_collected_objects.has(id) else 0
	

## Multipliers for each slot in the pachinco machine
@export var pachinko_multiplier: Array[int] = [1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1]
@export var pachinko_multiplier_upgrade_level: int = 0;
@export var pachinko_multiplier_upgrade_costs: Array[int] = [1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 4, 4, 4, 4, 4, 4, 4, 4, 4, 4, 4, 8, 8, 8, 8, 8, 8, 8, 8, 8, 8, 8, 16, 16, 16, 16, 16, 16, 16, 16, 16, 16, 16, 32, 32, 32, 32, 32, 32, 32, 32, 32, 32, 32, 64, 64, 64, 64, 64, 64, 64, 64, 64, 64, 64, 128, 128, 128, 128, 128, 128, 128, 128, 128, 128, 128, 256, 256, 256, 256, 256, 256, 256, 256, 256, 256, 256, 512, 512, 512, 512, 512, 512, 512, 512, 512, 512, 512]
## Snowballs per second for the main snowball throw
@export var throw_rate_upgrades: Array[float] = [0.5, 1, 2, 3, 5]
@export var throw_rate_upgrade_costs: Array[int] = [1, 10, 100, 1500]
@export var throw_rate_upgrade_level: int = 0;
var throw_rate: float:
	get:
		return throw_rate_upgrades[throw_rate_upgrade_level]

## Damage of the main snowball
@export var snowball_damage_upgrades: Array[int] = [1, 2, 3, 4, 5, 8, 15, 25, 40, 60, 80, 100, 120, 140, 160, 180, 200, 220, 240, 260, 280, 300, 320, 340, 360, 380, 400, 420, 440, 460, 480, 500, 520, 540, 560, 580, 600, 620, 640, 660, 680, 700, 720, 740, 760, 780, 800, 820, 840, 860, 880, 900, 920, 940, 960, 980, 1000]
@export var snowball_damage_upgrade_costs: Array[int] = [1, 10, 100, 1500, 3000, 6000, 12000, 24000, 48000, 96000, 192000, 384000, 768000, 1536000, 3072000, 6144000, 12288000, 24576000, 49152000, 98304000]
@export var snowball_damage_upgrade_level: int = 0;
var snowball_damage: int:
	get:
		return snowball_damage_upgrades[snowball_damage_upgrade_level]

## Speed of the main snowball
@export var snowball_speed_upgrades: Array[float] = [150.0, 175.0, 200.0, 225.0, 250.0, 300.0, 350.0, 400.0, 450.0, 500.0, 550.0, 600.0, 650.0, 700.0, 750.0, 800.0, 850.0, 900.0, 950.0, 1000.0]
@export var snowball_speed_upgrade_costs: Array[int] = [1, 10, 100, 1500, 3000, 6000, 12000, 24000, 48000, 96000, 192000, 384000, 768000, 1536000, 3072000, 6144000, 12288000, 24576000, 49152000, 98304000]
@export var snowball_speed_upgrade_level: int = 0;
var snowball_speed: float:
	get:
		return snowball_speed_upgrades[snowball_speed_upgrade_level]

## Move speed of the player
@export var player_move_speed_upgrades: Array[float] = [100.0, 150.0, 200.0, 300.0, 450.0, 600.0, 750.0, 900.0, 1050.0, 1200.0, 1350.0, 1500.0, 1650.0, 1800.0, 1950.0, 2100.0, 2250.0, 2400.0, 2550.0, 2700.0]
@export var player_move_speed_upgrade_costs: Array[int] = [1, 10, 100, 1500, 3000, 6000, 12000, 24000, 48000, 96000, 192000, 384000, 768000, 1536000, 3072000, 6144000, 12288000, 24576000, 49152000, 98304000]
@export var player_move_speed_upgrade_level: int = 0;
var player_move_speed: float:
	get:
		return player_move_speed_upgrades[player_move_speed_upgrade_level]

## Snowment per second spawn rate
@export var snowman_spawn_rate_upgrades: Array[float] = [0.2, 0.5, 1.0, 1.5, 2.0, 2.5, 3.0, 3.5, 4.0, 4.5, 5.0, 5.5, 6.0, 6.5, 7.0, 7.5, 8.0, 8.5, 9.0, 9.5, 10.0]
@export var snowman_spawn_rate_upgrade_costs: Array[int] = [1, 10, 100, 1500, 3000, 6000, 12000, 24000, 48000, 96000, 192000, 384000, 768000, 1536000, 3072000, 6144000, 12288000, 24576000, 49152000, 98304000]
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
@export var auto_backpack_fire_rate_upgrades: Array[float] = [0.5, 0.75, 1.0, 1.25, 1.5, 1.75, 2.0, 2.25, 2.5, 2.75, 3.0, 3.25, 3.5, 3.75, 4.0, 4.25, 4.5, 4.75, 5.0, 5.25, 5.5, 5.75, 6.0, 6.25, 6.5, 6.75, 7.0, 7.25, 7.5, 7.75, 8.0, 8.25, 8.5, 8.75, 9.0, 9.25, 9.5, 9.75, 10.0]
@export var auto_backpack_fire_rate_upgrade_costs: Array[int] = [15, 30, 60, 120, 240, 400, 600, 800, 1000, 1200, 1400, 1600, 1800, 2000, 2200, 2400, 2600, 2800, 3000, 3200, 3400, 3600, 3800, 4000, 4200, 4400, 4600, 4800, 5000, 5200, 5400, 5600, 5800, 6000, 6200, 6400, 6600, 6800, 7000]
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
