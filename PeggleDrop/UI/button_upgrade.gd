extends Button

@export var cost: int
@export var function_call: String
@export var name_string: String
@export var level: int

@onready var peggle_drop: PeggleDrop = $"../../../../../.."
@onready var game_data: GameData = peggle_drop.game_data
@onready var name_label: Label = $Name
@onready var level_label: Label = $Level

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	self.pressed.connect(_on_button_pressed)
	name_label.text = name_string + "\n" + "Cost: " + str(cost)

func _on_button_pressed() -> void:
	if cost > game_data.gold:
		pass
	
	self.call(function_call)
	game_data.gold -= cost
	level += 1
	level_label.text = str("LV: ", level)

func increase_multiplyer():
	var index = randi_range(0, game_data.pachinko_multipliers.size())
	game_data.pachinko_multipliers[index] *= 2
