extends Control

# Called when the "Start" button is pressed
func _on_start_button_pressed():
	get_tree().change_scene_to_file("res://main.tscn")  # Change to your actual game scene

# Called when the "How to Play" button is pressed
func _on_how_to_play_button_pressed():
	get_tree().change_scene_to_file("res://HowToPlayScene.tscn")  # Change to your actual How To Play scene
