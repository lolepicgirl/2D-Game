extends Control

# Called when the "Start" button is pressed
func _on_start_button_pressed():
	get_tree().change_scene_to_file("res://main.tscn")  # Change to your actual game scene

# Called when the "Quit" button is pressed
func _on_quit_button_pressed():
	get_tree().quit()  # Quit the game
