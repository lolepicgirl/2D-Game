extends CharacterBody2D

const SPEED = 100  # Adjust speed if needed

func _process(_delta):  # Prefix unused parameter with an underscore
	var direction = Vector2.ZERO  # No movement by default

	if Input.is_action_pressed("ui_right"):
		direction.x += 1
	if Input.is_action_pressed("ui_left"):
		direction.x -= 1
	if Input.is_action_pressed("ui_up"):
		direction.y -= 1
	if Input.is_action_pressed("ui_down"):
		direction.y += 1

	velocity = direction.normalized() * SPEED
	move_and_slide()
