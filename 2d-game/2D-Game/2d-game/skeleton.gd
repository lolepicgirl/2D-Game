extends CharacterBody2D

const GRAVITY = 500 # ADjust gravity strength if needed
const JUMP_FORCE = -300 # Adjust jump force
const SPEED = 50  # Adjust speed if needed
const ATTACK_COOLDOWN = 2.0 # Cooldown period in seconds
var attack_range = 50  # Define attack range
var health = 50 # Skeleton health
var is_attacking = false # Flag to indicate if the attack animation is playing
var is_hurt = false # Flag to indicate if the hurt animation is playing
var is_dead = false # Flag to indicate if the skeleton is dead
var last_attack_time = -ATTACK_COOLDOWN # Time of the last attack

@onready var attack_area = get_node("AttackArea")  # Reference to the attack collision area
@onready var player = null # Reference to the player node
@onready var animated_sprite = $AnimatedSprite2D # Reference to the AnimatedSprite2D node
@onready var attack_sound = $AttackSound # Reference to the AttackSound node
@onready var death_sound = $SkeletonDeath # Reference to the SkeletonDeath node
@onready var hurt_sound = $SkeletonHurt # Reference to the SkeletonHurt node

func _ready():
	# Find the player node
	player = get_parent().get_node("player")
	if player == null:
		print ("Player node not found! Attempting to find in the scene tree...")
		player = get_tree().root.get_node_or_null("root/player")
		if player == null:
			print ("player node not found in the entire scene tree.")
		else:
			print ("Player node found in the scene tree.")
	else:
		print("Player node found in the parent.")
		
func _process(delta) -> void:
	if is_dead:
		return
	
	var direction = Vector2.ZERO  # No movement by default
	
	# Move towards the player horizontally
	if player:
		var distance_to_player = global_position.distance_to(player.global_position)
		if distance_to_player < attack_range:
			direction.x = (player.global_position.x - global_position.x)
			direction = direction.normalized()

		else:
			direction = Vector2.ZERO
	
		# Move the skeleton
		velocity.x = direction.x * SPEED
		velocity.y = 0 # Restrict vertical movement
		move_and_slide()
	
		# Attack logic
		if player and distance_to_player <= attack_range and (Time.get_ticks_msec() / 1000.0 - last_attack_time >= ATTACK_COOLDOWN):
			attack()
		
		# Change animation based on movement and attack state
		if is_attacking:
			animated_sprite.play("attack")
		elif is_hurt:
			animated_sprite.play("hurt")
		elif direction == Vector2.ZERO:
			animated_sprite.play("idle")
		else:
			animated_sprite.play("walking")
		
	# Apply gravity
	if not is_on_floor():
		velocity.y += GRAVITY * delta
		
func attack():
	is_attacking = true
	last_attack_time = Time.get_ticks_msec() / 1000.0 # Updates the last attack time
	print("Skeleton attacks!")
	animated_sprite.play("attack")
	attack_sound.play()
	var bodies = attack_area.get_overlapping_bodies() # Get all the bodies in the are
	for body in bodies:
		if body.is_in_group("player") and body.has_method("take_damage"):
			body.take_damage()
		is_attacking = false

func take_damage():
	if is_dead:
		return
		
	health -= 10
	print("Enemy health: %d" % health)
	is_hurt = true
	animated_sprite.play("hurt")
	hurt_sound.play()
	await (get_tree().create_timer(0.5).timeout) # Wait for the hurt animation to finish
	is_hurt = false
		
	if health <= 0:
		die()

func die():
	is_dead = true
	velocity = Vector2.ZERO
	animated_sprite.play("dead") # Play death animation
	death_sound.play() # Play skeleton death sound
	
	animated_sprite.connect("animation_finished", Callable(self, "_on_AnimationFinished"))
	
func _on_animation_finished(anim_name: String):
	if anim_name == "dead":
		queue_free() # Remove the skeletons after they die
	elif anim_name == "attack":
		is_attacking = false
	elif anim_name == "hurt":
		is_hurt = false
	
