extends Camera2D

@export var target: Landing Page  # Drag your child node here in the Inspector

func _process(delta):
	if target:
		global_position = target.global_position
