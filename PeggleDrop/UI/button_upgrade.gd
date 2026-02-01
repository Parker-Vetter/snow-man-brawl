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
	upgrade_costs = game_data.get(upgrade_name + "_upgrade_costs")
	level = game_data.get(upgrade_name + "_upgrade_level")
	update_ui()


func _process(_delta: float) -> void:
	self.disabled = level >= upgrade_costs.size() - 1 or cost > game_data.gold


func _on_button_pressed() -> void:
	if cost > game_data.gold:
		return
	
	game_data.gold -= cost
	self.call(function_call)
	update_ui()
	button_sound.play()
	
func disable_if_needed():
	if level >= upgrade_costs.size() - 1 or cost > game_data.gold:
		self.disabled = true
	else:
		self.disabled = false

func update_ui() -> void:
	cost = upgrade_costs[level]
	name_label.text = name_string + "\n" + "Cost: " + str(cost)
	level_label.text = str("LV: ", level + 1)
	if level >= upgrade_costs.size() - 1:
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
