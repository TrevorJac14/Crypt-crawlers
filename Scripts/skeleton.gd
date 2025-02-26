extends Area2D

@export var shoot_cooldown = 2
@onready var Player = get_tree().get_first_node_in_group("Player")
@onready var shoot_timer = $ShootTimer
var bullet_scene = load("res://Scenes/projectile.tscn")

# Called when the node enters the scene tree for the first time.
func _ready():
	shoot_timer.start(shoot_cooldown)
	


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	if shoot_timer.is_stopped():
		shoot()
		shoot_timer.start(shoot_cooldown)


func shoot():
	var bullet = bullet_scene.instantiate()
	add_child(bullet)
	bullet.direction = global_position.direction_to(Player.global_position)
	bullet.global_position = global_position
