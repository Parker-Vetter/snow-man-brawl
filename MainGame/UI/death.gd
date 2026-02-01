extends Panel

@onready var main_game: MainGame = $"../../.."
@onready var game_data: GameData = main_game.gameData

@onready var snow_total: Label = $Snow/SnowTotal
@onready var carrot_total: Label = $Carrot/CarrotTotal
@onready var stick_total: Label = $Stick/StickTotal
@onready var coal_total: Label = $Coal/CoalTotal
@onready var kills: Label = $Statistics/KillsPanel/Kills
@onready var snow_balls_thrown: Label = $Statistics/SnowBallsThrownPanel/SnowBallsThrown
@onready var level_label: Label = $Statistics/LevelPanel/LevelLabel
@onready var lifetime_pickup_label: Label = $Statistics/LifetimePickupPanel/LifetimePickupLabel


func _on_return_pressed() -> void:
	get_tree().paused = not get_tree().paused
	main_game.switchToPeggleDrop()


func _on_retry_pressed() -> void:
	get_tree().paused = not get_tree().paused
	main_game.retryLevel()


func _on_visibility_changed() -> void:
	set_label(game_data.get_collected_object_count("snow"), snow_total)
	set_label(game_data.get_collected_object_count("carrot"), carrot_total)
	set_label(game_data.get_collected_object_count("stick"), stick_total)
	set_label(game_data.get_collected_object_count("coal"), coal_total)
	set_label(game_data.kills, kills)
	set_label(game_data.snow_balls_thrown, snow_balls_thrown)
	set_label(game_data.level, level_label)
	set_label(game_data.lifetime_pickup, lifetime_pickup_label)


func set_label(amount: int, label: Label):
	var object = amount
	if object == 0:
		label.text = str(0)
		label.self_modulate = Color.RED
	else:
		label.text = str(object)
		label.self_modulate = Color.WHITE
