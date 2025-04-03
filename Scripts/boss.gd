extends CharacterBody2D

const speed = 30
var dir: Vector2
var is_chase: bool
var damage = 50
@onready var Player = get_tree().get_first_node_in_group("player")

# Called when the node enters the scene tree for the first time.
func _ready():
	is_chase = false


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	move(delta)
	handle_animation()


func move(delta):
	if is_chase:
		if position.y == Player.position.y:
			velocity = position.direction_to(Player.position) * (speed * 4)
			dir.x  = abs(velocity.x) / velocity.x
		elif position.y != Player.position.y:
			velocity.y = position.direction_to(Player.position).y * (speed * 2)
			velocity.x = position.direction_to(Player.position).x * (speed * 3)
			dir.x  = abs(velocity.x) / velocity.x
	elif !is_chase:
		velocity += dir * speed * delta
	move_and_slide()


func choose(array):
	array.shuffle()
	return array.front()


func handle_animation():
	var animated_sprite = $AnimatedSprite2D
	if !is_chase or is_chase:
		if !is_chase:
			animated_sprite.play("default")
		elif is_chase:
			animated_sprite.play("chase")
		if dir.x == -1:
			animated_sprite.flip_h = true
		elif dir.x == 1:
			animated_sprite.flip_h = false


func _on_direction_timer_timeout():
	$DirectionTimer.wait_time = choose([1.0,1.5,2.0])
	if !is_chase:
		dir = choose([Vector2.RIGHT, Vector2.UP, Vector2.LEFT, Vector2.DOWN])


func _on_chase_timer_timeout():
	pass # Replace with function body.


func _on_interval_timer_timeout():
	var mode_shift = choose([1,1,2])
	if mode_shift == 2:
		is_chase = true
	elif mode_shift == 1:
		is_chase = false


func _on_area_2d_body_entered(body):
	if body.has_method("take_damage"):
		body.take_damage(damage)
