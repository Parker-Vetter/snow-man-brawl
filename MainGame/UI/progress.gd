extends ProgressBar

@onready var main_game: MainGame = $"../../../.."
@onready var time_left: Timer = $"../../../../TimeLeft"

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	time_left.start(main_game.gameData.game_length)


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _physics_process(delta: float) -> void:
	self.max_value = main_game.gameData.game_length
	self.value = time_left.time_left


func _on_time_left_timeout() -> void:
	main_game.pause_and_death_menu()
