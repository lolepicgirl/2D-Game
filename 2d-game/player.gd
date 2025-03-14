extends CharacterBody2D

const SPEED = 100  # Adjust speed if needed
var attack_range = 50  # Define attack range

@onready var attack_area = get_node("AttackArea")  # Reference to the AttackArea node

func _ready():
	# Debugging check: Ensure AttackArea is assigned properly
	if attack_area == null:
		print("Error: AttackArea is not found!")
	else:
		print("AttackArea node found: ", attack_area)

func _process(_delta):
	var direction = Vector2.ZERO  # No movement by default

	# Handle movement inputs
	if Input.is_action_pressed("ui_right"):
		direction.x += 1
	if Input.is_action_pressed("ui_left"):
		direction.x -= 1
	if Input.is_action_pressed("ui_up"):
		direction.y -= 1
	if Input.is_action_pressed("ui_down"):
		direction.y += 1

	# Change animation based on movement
	if direction == Vector2.ZERO: 
		$AnimatedSprite2D.play("default")
	else:
		$AnimatedSprite2D.play("walking")

	# Move the character
	velocity = direction.normalized() * SPEED
	move_and_slide()

	# Attack logic (when the player presses the "attack" button)
	if Input.is_action_just_pressed("attack"):
		attack()

func attack():
	print("Player attacks!")
	if attack_area != null:
		var bodies = attack_area.get_overlapping_bodies()  # Get all bodies in the attack area
		for body in bodies:
			if body.is_in_group("skeletons") and body.has_method("take_damage"):
				body.take_damage()  # Call the take_damage() method on skeletons
	else:
		print("AttackArea is null!")  # Print a message if AttackArea is null
