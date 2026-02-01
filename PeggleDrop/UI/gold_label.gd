extends Label

@onready var peggle_drop: PeggleDrop = $"../../../../.."


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _physics_process(delta: float) -> void:
	self.text = "Gold: " + str(peggle_drop.game_data.gold)
