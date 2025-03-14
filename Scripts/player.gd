extends CharacterBody2D


var throw_scene = load("res://Scenes/player_throw.tscn")
var throw_direction
var SPEED = 130.0
const JUMP_VELOCITY = -300.0
var gravity = ProjectSettings.get_setting("physics/2d/default_gravity")
const GRAVITY = 2000.0
var health = 20
var max_health = 100
var mana = 0
var max_mana = 20
var is_dead = false
var is_attacking = false
var strength = 5

@onready var animated_sprite = $AnimatedSprite2D
@onready var timer = $Timer
@onready var melee_hitbox = $"Melee hitbox"

func _physics_process(delta: float) -> void:
	# Add the gravity.
	if not is_on_floor():
		velocity += get_gravity() * delta
	# Handle jump.
	if Input.is_action_just_pressed("jump") and is_on_floor() && is_dead == false:
		velocity.y = JUMP_VELOCITY
	# Get the input direction and handle the movement/deceleration.
	var direction := Input.get_axis("move_left", "move_right")
	#flip the sprite
	if direction > 0 && is_dead == false:
		animated_sprite.flip_h = false
		melee_hitbox.position.x = 10
	elif direction < 0 && is_dead == false:
		animated_sprite.flip_h = true
		melee_hitbox.position.x = -10
	#play animations
	if is_on_floor() && is_dead == false && is_attacking == false:
		if direction == 0:
			animated_sprite.play("idle")
		else:
			animated_sprite.play("run")
	elif is_dead == false && is_attacking == false:
		animated_sprite.play("jump")
	if direction && is_dead == false:
		velocity.x = direction * SPEED
	else:
		velocity.x = move_toward(velocity.x, 0, SPEED)
	move_and_slide()
	# Handles Attacking
	if Input.is_action_just_pressed("primary") && is_dead == false:
		print("You are attacking")
		is_attacking = true
		%MeleeShape.disabled = false
		animated_sprite.play("attack")
		
	if velocity.x < 0:
		throw_direction = -1
	elif velocity.x > 0:
		throw_direction = 1
	else:
		throw_direction = throw_direction

	if Input.is_action_just_pressed("throw"):
		throw()

func throw():
	if mana > 0:
		mana -= 5
		var thrown_object = throw_scene.instantiate()
		var face_direction = Vector2.RIGHT
		get_parent().add_child(thrown_object)
	
		thrown_object.global_position = $ThrowPoint.global_position
		if throw_direction == 1:
			face_direction = Vector2.RIGHT
		elif throw_direction == -1:
			face_direction = Vector2.LEFT
		thrown_object.direction = face_direction


func _on_area_entered(area) -> void:
	if area.is_in_group("arrow"):
		health -= 5

func restore_mana(amount):
	for i in amount:
		if mana < max_mana:
			mana += 1
			print (mana)
	
func restore_health(amount):
	for i in amount:
		if health < max_health:
			health += 1
			print (health)
	
# Handles Subweapon Attacking
func take_damage(amount: int) -> void:
	health -= amount
	print("Player health:", health)
	$AudioStreamPlayer2D.play()
	if health <= 0:
		die()
func die() -> void:
	print("You died")
	is_dead = true
	Engine.time_scale = 0.5
	animated_sprite.play("death")
	#get_node("CollisionShape2D").queue_free()
	timer.start()
func _on_timer_timeout() -> void:
	Engine.time_scale = 1
	get_tree().reload_current_scene()

func _on_animated_sprite_2d_animation_finished() -> void:
	if animated_sprite.animation == "attack":
		%MeleeShape.disabled = true
		is_attacking = false


func _on_melee_hitbox_area_entered(area):
	if area.is_in_group("arrow"):
		take_damage(20)
