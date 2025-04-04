
extends Area2D


@export var throw_speed = 400
var screen_size
var direction = Vector2.ZERO

# Called when the node enters the scene tree for the first time.
func _ready():
	screen_size = get_viewport_rect().size
	


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _physics_process(delta):
	position += direction.normalized() * throw_speed * delta


func _on_visible_on_screen_notifier_2d_screen_exited():
	queue_free()
	print("thrown projectile removed")
