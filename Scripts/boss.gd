extends CharacterBody2D

const speed = 25
var deceleration = 45.0  # Adjust as needed
var dir: Vector2
var is_chase: bool
var damage = 15
var health = 10
var dead = false

@onready var Player = get_tree().get_first_node_in_group("player")

# Called when the node enters the scene tree for the first time.
func _ready():
	is_chase = false


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	move(delta)
	handle_animation()


func get_player_camera():
	return Player.get_node("Camera2D")

func move(delta):
	if !dead:
		if is_chase:
			Player = get_tree().get_first_node_in_group("player")
			velocity = position.direction_to(Player.position) * (speed * 4)
			dir  = abs(velocity) / velocity
			move_and_slide()
		elif !is_chase:
			velocity += (dir * speed * delta)
			if velocity.length() > 15:
				velocity = velocity.move_toward(Vector2.ZERO, deceleration * delta)
			move_and_slide()
	elif dead:
		velocity = Vector2.ZERO * 0
		




func choose(array):
	array.shuffle()
	return array.front()


func handle_animation():
	var animated_sprite = $AnimatedSprite2D
	if !is_chase or is_chase or dead:
		if !is_chase and !dead:
			animated_sprite.play("default")
		elif is_chase and !dead:
			animated_sprite.play("chase")
		if dir.x == -1:
			animated_sprite.flip_h = true
		elif dir.x == 1:
			animated_sprite.flip_h = false
		if dead: 
			animated_sprite.play("die")


func _on_direction_timer_timeout():
	$DirectionTimer.wait_time = choose([1.0,1.5,2.0])
	if !is_chase:
		dir = choose([Vector2.RIGHT, Vector2.UP, Vector2.LEFT, Vector2.DOWN])


func _on_chase_timer_timeout():
	pass # Replace with function body.


func _on_interval_timer_timeout():
	if !dead:
		var mode_shift = choose([1,2])
		if mode_shift == 2:
			is_chase = true
		elif mode_shift == 1:
			is_chase = false
	else:
		is_chase = false


func _on_area_2d_body_entered(body):
	if !dead:
		if body.has_method("take_damage"):
			body.take_damage(damage)
			is_chase = false


func death():
	dead = true
	$AudioStreamPlayer2D.play()
	
func _on_audio_stream_player_2d_finished():
	queue_free()


func _on_area_2d_area_entered(area):
	if area.is_in_group("sword"):
		health -= 1
		print("BOSS HIT")
		$HItAudioStreamPlayer2D.play()
		if health <= 0:
			death()
