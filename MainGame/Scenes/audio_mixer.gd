extends AudioStreamPlayer
@onready var main_game: MainGame = $".."

@export var music_tracks: Array[AudioStream] = []

@onready var numTracks = music_tracks.size()

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	var round = main_game.gameData.rounds_played
	var index = round%numTracks
	
	stream = music_tracks[index]
	self.play()
