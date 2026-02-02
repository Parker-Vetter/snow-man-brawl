extends AudioStreamPlayer
@onready var main_game: MainGame = $".."

@export var music_tracks: Array[AudioStream] = []

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	var round = main_game.gameData.rounds_played-1	
	stream = music_tracks[music_tracks.size()%round]
	self.play()
