extends Area2D

@onready var audio_stream = $AudioStreamPlayer2D
@onready var deathsound = $Deathsound
@export var shoot_cooldown = 2
@export var path: Path2D  # Assign in Inspector
@export var speed: float = 100.0  # Movement speed
@onready var Player = get_tree().get_first_node_in_group("Player")
@onready var shoot_timer = $ShootTimer
var progress: float = 0.0  # Track movement along the path
var curve: Curve2D  # Stores the path's curve
var health = 10
var hit = false
var onScreen = false
var bullet_scene = load("res://Scenes/projectile.tscn")
var damage = 5
var is_dead = false

# Called when the node enters the scene tree for the first time.
func _ready():
	shoot_timer.start(shoot_cooldown)
	if path:
		curve = path.curve  # Get the path's curve

	


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	if shoot_timer.is_stopped():
		shoot()
		shoot_timer.start(shoot_cooldown)
		progress += speed * delta  # Move along the path
	if curve:
		progress += speed * delta  # Move forward along the path
		progress = fmod(progress, curve.get_baked_length())  # Loop movement
		global_position = curve.sample_baked(progress)  # Move to new position
	
func play_animation(animation):
	if animation == "die":
		$AnimatedSprite2D.play("die")
	if animation == "idle":
		$AnimatedSprite2D.play("idle")


func shoot():
	if !is_dead:
		if onScreen:
			if Player.global_position.x > global_position.x:
				$AnimatedSprite2D.flip_h = true
			else:
				$AnimatedSprite2D.flip_h = false
			var bullet = bullet_scene.instantiate()
			add_child(bullet)
			bullet.direction = global_position.direction_to(Player.global_position)
			bullet.global_position = global_position
			bullet.rotation = bullet.direction.angle()

func death():
	is_dead = true
	play_animation("die")
	deathsound.play()


func _on_area_entered(area) -> void:
	if area.is_in_group("sword"):
		hit = true
		print("skeleton hit")
		health -= 5
		audio_stream.play()
	if health <= 0:
		death()

func _on_body_entered(body: Node2D) -> void:
	print("You bumped into skelly bean")
	if body.has_method("take_damage"):
		body.take_damage(damage)

func _on_visible_on_screen_notifier_2d_screen_entered():
	onScreen = true

func _on_visible_on_screen_notifier_2d_screen_exited():
	onScreen =false


func _on_deathsound_finished() -> void:
	queue_free()
