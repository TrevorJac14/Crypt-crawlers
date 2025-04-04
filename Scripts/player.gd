extends CharacterBody2D
@onready var hp_bar = $Control/HPBar
@onready var mp_bar = $Control/MPBar
signal has_died
var throw_scene = load("res://Scenes/player_throw.tscn")
var throw_direction
var SPEED = 130.0
const JUMP_VELOCITY = -300.0
var gravity = ProjectSettings.get_setting("physics/2d/default_gravity")
const GRAVITY = 2000.0
var health = 100
var max_health = 100
var mana = 100
var max_mana = 100
var can_take_damage = true
var is_dead = false
var is_attacking = false
var can_throw = true
var is_knocked_back = false
var strength = 5
var enemy_position

@onready var animated_sprite = $AnimatedSprite2D
@onready var timer = $Timer
@onready var melee_hitbox = $"Melee hitbox"

func _ready():
	$CanThrowTimer.start()

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
	if direction > 0 && is_dead == false && !is_knocked_back:
		animated_sprite.flip_h = false
		melee_hitbox.position.x = 14
	elif direction < 0 && is_dead == false && !is_knocked_back:
		animated_sprite.flip_h = true
		melee_hitbox.position.x = -14
	#play animations
	if is_on_floor() && is_dead == false && is_attacking == false:
		if direction == 0:
			animated_sprite.play("idle")
		else:
			animated_sprite.play("run")
			$WalkSound.play()
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
	if can_throw:
		can_throw = false
		$CanThrowTimer.start()
		if mana > 0:
			mana -= 5
			mp_bar.value = mana
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
			mana += 50
			print (mana)
	
func restore_health(amount):
	for i in amount:
		if health < max_health:
			health += 50
			print (health)
	
# Handles Subweapon Attacking
func take_damage(amount: int) -> void:
	if can_take_damage:
		health -= amount
		print("Player health:", health)
		$AudioStreamPlayer2D.play()
		hp_bar.value = health
		apply_knockback(amount)
		if health <= 0:
			die()

func apply_knockback(amount):
	is_knocked_back = true
	velocity.y = JUMP_VELOCITY
	can_take_damage = false
	$AnimatedSprite2D.modulate = Color(1,0,0,1)
	await get_tree().create_timer(0.5).timeout
	$AnimatedSprite2D.modulate = Color(1, 1, 1, 1)
	is_knocked_back = false
	if !is_dead:
		can_take_damage = true
	

func die() -> void:
	print("You died")
	is_dead = true
	Engine.time_scale = 0.5
	animated_sprite.play("death")
	#get_node("CollisionShape2D").queue_free()
	timer.start()
	has_died.emit()  # Emit the signal when the player dies
	
func _on_timer_timeout() -> void:
	Engine.time_scale = 1
	#get_tree().reload_current_scene()

func _on_animated_sprite_2d_animation_finished() -> void:
	if animated_sprite.animation == "attack":
		%MeleeShape.disabled = true
		is_attacking = false


func _on_melee_hitbox_area_entered(area):
	if area.is_in_group("arrow"):
		take_damage(20)

func showing_bars():
	if mp_bar.value < 50:
		mp_bar.show
	else:
		mp_bar.hide
	if hp_bar.value < 100:
		hp_bar.show
	else:
		hp_bar.hide


func _on_can_throw_timer_timeout():
	can_throw = true
