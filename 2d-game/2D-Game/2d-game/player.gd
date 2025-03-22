extends CharacterBody2D

const SPEED = 100  # Adjust speed if needed
const GRAVITY = 500 # Adjust gravity strength if needed
const JUMP_FORCE = -300 # Adjust jump force
var is_attacking = false # Flag to indicate if the attack animation is playing
var health = 100 # Character health
var attack_range = 50

@onready var attack_area = get_node("AttackArea")  # Reference to the AttackArea node
@onready var animated_sprite = $AnimatedSprite2D # Reference to the AnimatedSprite2D node
@onready var attack_sound = $AttackSound # Reference to the AttackSound node
@onready var death_sound = $DeathSound # Reference to the DeathSound node
@onready var hurt_sound = $HurtSound # Reference to the HurtSound node

func _ready():
	# Connect the animation finished signal
	animated_sprite.connect("animation_finished", Callable(self, "_on_AnimationFinished"))

func _process(delta: float) -> void:
	var direction = Vector2.ZERO  # No movement by default

	# Handle movement inputs only if not attacking
	if not is_attacking:
		if Input.is_action_pressed("ui_right"):
			direction.x += 1
			animated_sprite.flip_h = false # Face right
		if Input.is_action_pressed("ui_left"):
			direction.x -= 1
			animated_sprite.flip_h = true # Face left
		
		# Handle Jump
		if Input.is_action_just_pressed("ui_up") and is_on_floor():
			jump()
		
	# Apply gravity
	if not is_on_floor():
		velocity.y += GRAVITY * delta

	# Change animation based on movement and attack state
	if is_attacking:
		animated_sprite.play("attack")
	elif not is_on_floor():
		animated_sprite.play("jumping")
	elif direction == Vector2.ZERO:
		animated_sprite.play("default")
	else:
		animated_sprite.play("walking")
	
	# Move the character only if not attacking
	if not is_attacking:
			velocity.x = direction.x * SPEED
			move_and_slide()

	# Attack logic (when the player presses the "attack" button)
	if Input.is_action_just_pressed("ui_select") and not is_attacking: # "ui_select" is mapped to the spacebar
		attack()

func jump():
	velocity.y = JUMP_FORCE # Apply jump force

func attack():
	is_attacking = true
	print("Player attacks!")
	animated_sprite.play("attack") # Play the attack animation
	attack_sound.play() # Play the attack sound
	var bodies = attack_area.get_overlapping_bodies()  # Get all bodies in the attack area
	for body in bodies:
		if body.is_in_group("skeletons") and body.has_method("take_damage"):
			body.take_damage()  # Call the take_damage() method on skeletons

func _on_AnimationFinished():
	# Ensure the attack animation has finished
	if animated_sprite.animation == "attack":
			is_attacking = false

func take_damage():
	hurt_sound.play # Play the hurt sound
	health -= 10
	print("Player health: %d" % health)
	if health <= 0:
		death_sound.play() # Play the death sound
		animated_sprite.play("death") # Play death animation
		print("Player is dead") # Handle player death
