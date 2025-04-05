extends Area2D


@export var bullet_speed = 200
var screen_size
var direction = Vector2.ZERO
var damage = 12


# Called when the node enters the scene tree for the first time.
func _ready():
	screen_size = get_viewport_rect().size
	$AnimatedSprite2D.play("default")
	

func _on_body_entered(body: Node2D) -> void:
	print("You got hit")
	if body.has_method("take_damage"):
		body.take_damage(damage)

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _physics_process(delta):
	position += direction * bullet_speed * delta


func _on_visible_on_screen_notifier_2d_screen_exited():
	queue_free()
	#print("bullet removed")
