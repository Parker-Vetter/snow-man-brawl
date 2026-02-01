extends ProgressBar

@onready var main_game: MainGame = $"../../../.."
@onready var nine_patch_rect: NinePatchRect = $"../LevelReadyButton"
@onready var button_hold_progress: ProgressBar = $"../LevelReadyButton/ButtonHoldProgress"
@onready var level_label: Label = $"../LevelLabel"

var buttonProgress:float = 0

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	self.max_value = main_game.gameData.resources_needed_to_progress
	self.value = 0
	level_label.text = "Level " + str(main_game.gameData.level)
	
func _process(delta: float) -> void:
	self.value = min(main_game.gameData.resources_collected_this_level, self.max_value)
	if main_game.gameData.ready_for_level_transition:
		nine_patch_rect.visible = true
		if Input.is_action_pressed("Shoot"):
			buttonProgress += delta
			if(buttonProgress >= 1):
				main_game.nextLevel()
		else:
			buttonProgress = 0
		button_hold_progress.value = buttonProgress *100
		
