extends AudioStreamPlayer2D

const level_music = preload("res://2d-game/2d-game/horror-ambience-3-303646.mp3")

func _play_music(music_stream: AudioStream, volume = 0.0):  # Renamed parameter to music_stream
	if stream == music_stream:
		return
		
	stream = music_stream
	volume_db = volume
	play()
	
	
var music_player: AudioStreamPlayer  # Renamed variable to music_player

func _play_music_level():
	_play_music(level_music)
