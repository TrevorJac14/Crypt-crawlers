extends Area2D


@export var shoot_cooldown = 2
@onready var Player = get_tree().get_first_node_in_group("Player")
@onready var shoot_timer = $ShootTimer
@export var stop_duration: float = 1  # Time to stop when shooting

var health = 10
var hit = false
var onScreen = false
var bullet_scene = load("res://Scenes/projectile.tscn")
var damage = 5
var last_position: Vector2

# Called when the node enters the scene tree for the first time.
func _ready():
	shoot_timer.start(shoot_cooldown)
	last_position = global_position  # Set initial position
	$AnimatedSprite2D.play("walk")
	

	


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	if shoot_timer.is_stopped():
		shoot()
		shoot_timer.start(shoot_cooldown)
	if global_position.distance_to(last_position) > 0.1:
		$AnimatedSprite2D.play("walk")  # Play walking animation when moving
	else:
		$AnimatedSprite2D.play("idle")  # Switch to idle if not moving
	
	 # Flip sprite based on movement direction
	if global_position.x > last_position.x:
		$AnimatedSprite2D.flip_h = true  # Moving right
	elif global_position.x < last_position.x:
		$AnimatedSprite2D.flip_h = false  # Moving left
	last_position = global_position  # Update last position
	
	
func shoot():
	if is_player_infront(Player):
		if onScreen:
			var bullet = bullet_scene.instantiate()
			var facing_direction = Vector2.RIGHT if $AnimatedSprite2D.flip_h == true else Vector2.LEFT
			var path_follow = get_parent()  # Get the PathFollow2D node
			var previous_speed

			if path_follow is PathFollow2D:
				previous_speed = path_follow.get("speed")  # Save speed before stopping
				path_follow.set("speed", 0)  # Stop movement

			get_tree().current_scene.add_child(bullet)
			bullet.direction = facing_direction
			bullet.global_position = global_position
			bullet.rotation = bullet.direction.angle()
			await get_tree().create_timer(stop_duration).timeout

			if path_follow is PathFollow2D:
				path_follow.set("speed", previous_speed)  # Restore speed


func is_player_infront(player: Node2D) -> bool:
	var player_x = player.global_position.x
	var enemy_x = global_position.x
	var facing_right = !$AnimatedSprite2D.flip_h  # Not flipped means facing right

	if facing_right and player_x < enemy_x:
		return true  # Enemy faces right & player is to the right
	elif not facing_right and player_x > enemy_x:
		return true  # Enemy faces left & player is to the left
	return false

func _on_area_entered(area) -> void:
	if area.is_in_group("sword"):
		hit = true
		print("skeleton hit")
		health -= 5
	if health <= 0:
		print("skeletor slain lol")
		$AnimatedSprite2D.play("die")
		#await $AnimatedSprite2D.animation_finished
		queue_free()

func _on_body_entered(body: Node2D) -> void:
	print("You bumped into skelly bean")
	if body.has_method("take_damage"):
		body.take_damage(damage)

func _on_visible_on_screen_notifier_2d_screen_entered():
	onScreen = true

func _on_visible_on_screen_notifier_2d_screen_exited():
	onScreen =false
