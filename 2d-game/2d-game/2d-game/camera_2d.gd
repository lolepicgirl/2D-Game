extends Camera2D

@export var target: Node2D

func _process(delta):
	if target:
		global_position = target.global_position
