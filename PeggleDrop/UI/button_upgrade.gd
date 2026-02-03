extends Button

@export var function_call: String
@export var name_string: String
@export var upgrade_name: String

@onready var peggle_drop: PeggleDrop = $"../../../../../.."
@onready var game_data: GameData = peggle_drop.game_data
@onready var name_label: Label = $Name
@onready var level_label: Label = $Level
@onready var button_sound:AudioStreamPlayer =%Button

var upgrade_costs: Array[int];

var cost: int
var level: int
# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	self.pressed.connect(_on_button_pressed)
	game_data.gold_changed.connect(_on_gold_changed)
	upgrade_costs = game_data.get(upgrade_name + "_upgrade_costs")
	level = game_data.get(upgrade_name + "_upgrade_level")
	update_ui()

func _on_gold_changed(_new_amount: int) -> void:
	disable_if_needed()

func _on_button_pressed() -> void:
	if cost > game_data.gold:
		return
	
	disable_if_needed()
	game_data.gold -= cost
	self.call(function_call)
	
	button_sound.play()

func disable_if_needed():
	var should_disable = level >= upgrade_costs.size() or cost > game_data.gold

	# Disable fire rate upgrade if no auto backpack owned
	if upgrade_name == "auto_backpack_fire_rate" and game_data.auto_backpack == 0:
		should_disable = true

	if should_disable:
		self.disabled = true
		name_label.add_theme_color_override("font_color", Color.WHITE)
		level_label.add_theme_color_override("font_color", Color.WHITE)
	else:
		self.disabled = false
		name_label.self_modulate = Color.BLACK
		level_label.self_modulate = Color.BLACK

func update_ui() -> void:
	cost = upgrade_costs[level] if level < upgrade_costs.size() else 0
	name_label.text = name_string + "\n" + "Cost: " + str(cost)
	level_label.text = str("LV: ", level + 1)
	if level >= upgrade_costs.size():
		name_label.text = name_string + "\n" + "Max Level"
	else:
		name_label.text = name_string + "\n" + "Cost: " + str(cost)
	disable_if_needed()


func increase_multiplyer():
	var index = randi_range(0, game_data.pachinko_multiplier.size() - 1)
	game_data.pachinko_multiplier[index] += 1
	increase_basic_level()
	update_ui()

func increase_basic_level():
	level += 1
	game_data.set(upgrade_name + "_upgrade_level", level)
	update_ui()
