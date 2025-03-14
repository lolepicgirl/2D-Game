extends CharacterBody2D

const SPEED = 100  # Adjust speed if needed
var attack_range = 50  # Define attack range

@onready var attack_area = $AttackArea  # Reference to the attack collision area

func _process(_delta):
	var direction = Vector2.ZERO  # No movement by default

	if Input.is_action_pressed("ui_right"):
		direction.x += 1
	if Input.is_action_pressed("ui_left"):
		direction.x -= 1
	if Input.is_action_pressed("ui_up"):
		direction.y -= 1
	if Input.is_action_pressed("ui_down"):
		direction.y += 1

	if direction == Vector2.ZERO: 
		$AnimatedSprite2D.play("default")
	else:
		$AnimatedSprite2D.play("walking")

	velocity = direction.normalized() * SPEED
	move_and_slide()

	# Attack logic
	if Input.is_action_just_pressed("attack"):
		attack()

func attack():
	print("Player attacks!")
	var bodies = attack_area.get_overlapping_bodies()
	for body in bodies:
		if body.is_in_group("skeletons") and body.has_method("take_damage"):
			body.take_damage()
