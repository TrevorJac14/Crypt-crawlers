extends Area2D

var hit = false
var health = 10
func _ready():
	pass

func _process(_delta):
	if hit == false:
		$AnimatedSprite2D.play("idle")

func _on_area_entered(area) -> void:
	if area.is_in_group("sword"):
		hit = true
		$AnimatedSprite2D.play("hurt")
		health -= 5
		if health <= 0:
			death()

func death():
	queue_free()


func _on_animated_sprite_2d_animation_finished() -> void:
	if $AnimatedSprite2D.animation == "hurt":
		hit = false
