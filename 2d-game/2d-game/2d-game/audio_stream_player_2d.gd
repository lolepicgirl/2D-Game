extends AudioStreamPlayer2D

const level_music = preload("res://2d-game/2d-game/horror-ambience-3-303646.mp3")

func _play_music(music: AudioStream, volume = 0.0):
	if stream == music:
		return
		
	stream = music
	volume_db = volume
	play()
	
	
var music: AudioStreamPlayer

func _play_music_level():
	_play_music(level_music)
