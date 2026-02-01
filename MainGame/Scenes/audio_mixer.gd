extends AudioStreamPlayer
@onready var main_game: MainGame = $".."

@export var music_tracks: Array[AudioStream] = []

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	var data = main_game.gameData
	var percentage = data.getUpgradePercentage();
	stream = music_tracks[percentage * music_tracks.size()]
	self.play()
