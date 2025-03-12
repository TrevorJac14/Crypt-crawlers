extends Area2D


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


func shoot():
	if onScreen:
		var bullet = bullet_scene.instantiate()
		add_child(bullet)
		bullet.direction = global_position.direction_to(Player.global_position)
		bullet.global_position = global_position
		bullet.rotation = bullet.direction.angle()

func death():
	play_animation("die")
	queue_free()


func _on_area_entered(area) -> void:
	if area.is_in_group("sword"):
		hit = true
		print("skeleton hit")
		health -= 5
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
