class_name Multiplyer
extends Area2D

var multiplyer: int = 1
@onready var label: Label = $Label

@export var index: int
@export var gameData: GameData

var currentMult = multiplyer

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.

func _physics_process(delta: float) -> void:
	if not gameData:
		return
	multiplyer = gameData.pachinko_multipliers[index]
	label.text = str(multiplyer) + "X"
	if currentMult != multiplyer:
		currentMult = multiplyer
		#playAnimation for index
		pass

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass


func _on_body_entered(body: Node2D) -> void:
	if body is RigidBody2D:
		body.value *= multiplyer


func _on_input_event(viewport: Node, event: InputEvent, shape_idx: int) -> void:
	if event is InputEventMouseButton and event.button_index == MOUSE_BUTTON_LEFT and event.pressed:
		print("Clicked!")
		multiplyer += 1
