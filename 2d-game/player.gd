extends CharacterBody2D

const SPEED = 100  # Adjust speed if needed
var attack_range = 50  # Define attack range
var is_attacking = false # Flag to indicate if the attack animation is playing

@onready var attack_area = get_node("AttackArea")  # Reference to the AttackArea node
@onready var animated_sprite = $AnimatedSprite2D # Reference to the AnimatedSprite2D node

func _ready():
	# Debugging check: Ensure AttackArea is assigned properly
	if attack_area == null:
		print("Error: AttackArea is not found!")
	else:
		print("AttackArea node found: ", attack_area)
		
	# Connect the animation finished signal
	animated_sprite.connect("animation_finished", Callable(self, "_on_AnimationFinished"))

func _process(delta: float) -> void:
	var direction = Vector2.ZERO  # No movement by default

	# Handle movement inputs
	if Input.is_action_pressed("ui_right"):
		direction.x += 1
		animated_sprite.flip_h = false # Face right
	if Input.is_action_pressed("ui_left"):
		direction.x -= 1
		animated_sprite.flip_h = true # Face left
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
	if Input.is_action_just_pressed("ui_select"): # "ui_select" is mapped to the spacebar
		attack()

func attack():
	if not is_attacking:
		is_attacking = false
		print("Player attacks!")
		animated_sprite.play("attack") # Play the attack animation
		if attack_area != null:
			var bodies = attack_area.get_overlapping_bodies()  # Get all bodies in the attack area
			for body in bodies:
				if body.is_in_group("skeletons") and body.has_method("take_damage"):
					body.take_damage()  # Call the take_damage() method on skeletons
		else:
			print("AttackArea is null!")  # Print a message if AttackArea is null

func _on_AnimationFinished():
	# Ensure the attack animation has finished
	if animated_sprite.animation == "attack":
			$AnimatedSprite2D.play("attack")
