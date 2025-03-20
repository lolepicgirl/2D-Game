extends CharacterBody2D

const GRAVITY = 500 # ADjust gravity strength if needed
const JUMP_FORCE = -300 # Adjust jump force
const SPEED = 50  # Adjust speed if needed
var attack_range = 5  # Define attack range
var health = 50 # Skeleton health
var is_attacking = false # Flag to indicate if the attack animation is playing

@onready var attack_area = $AttackArea  # Reference to the attack collision area
@onready var player = null # Reference to the player node
@onready var animated_sprite = $AnimatedSprite2D # Reference to the AnimatedSprite2D node
@onready var attack_sound = $AttackSound # Reference to the AttackSound node
@onready var death_sound = $SkeletonDeath # Reference to the SkeletonDeath node
@onready var hurt_sound = $SkeletonHurt # Reference to the SkeletonHurt node

func _ready():
	# Find the player node
	player = get_parent().get_node("player")

func _process(delta: float) -> void:
	var direction = Vector2.ZERO  # No movement by default
	
	# Move towards the player
	if player:
		var distance_to_player = global_position.distance_to(player.global_position)
		if distance_to_player < attack_range:
			direction = (player.global_position - global_position).normalized()
		else:
			direction = Vector2.ZERO
	
		# Move the enemy
		velocity = direction * SPEED
		move_and_slide()
	
		# Attack logic
		if player and distance_to_player <= attack_range:
			attack()
		
		# Change animation based on movement and attack state
		if is_attacking:
			animated_sprite.play("attack")
		elif direction == Vector2.ZERO:
			animated_sprite.play("idle")
		else:
			animated_sprite.play("walking")
	
	# Move the character only if not attacking
	if not is_attacking:
			velocity.x = direction.x * SPEED
			move_and_slide()
		
	# Apply gravity
	if not is_on_floor():
		velocity.y += GRAVITY * delta
		
func attack():
	print("Player hit!")
	var bodies = attack_area.get_overlapping_bodies()
	for body in bodies:
		if body.is_in_group("player") and body.has_method("take_damage"):
			body.take_damage()

func take_damage():
	health -= 10
	print("Enemy health: d%" % health)
	animated_sprite.play("hurt")
	if health <= 0:
		animated_sprite.play("dead") # Play death animation
		death_sound.play() # Play skeleton death sound
