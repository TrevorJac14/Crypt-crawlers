extends Area2D

var damage = 10

func _on_body_entered(body: Node2D) -> void:
	print("You got hit")
	if body.has_method("take_damage"):
		body.take_damage(damage)
