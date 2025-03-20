extends CharacterBody2D

const SPEED = 100  # Adjust speed if needed
var attack_range = 50  # Define attack range

@onready var attack_area = $AttackArea  # Reference to the attack collision area

func _process(_delta):
	var direction = Vector2.ZERO  # No movement by default

func _physics_process(delta):
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
