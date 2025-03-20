extends Control

func _on_how_to_play_pressed() -> void:
	get_tree().change_scene_to_file("res://2D-Game/2d-game/HowToPlay.tscn")


func _on_start_game_pressed() -> void:
	get_tree().change_scene_to_file("res://2D-Game/2d-game/castlefacade.tscn")
