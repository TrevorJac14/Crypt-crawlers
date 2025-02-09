extends Area2D


# Called when the node enters the scene tree for the first time.
func _on_body_entered(body):
	print("Got Hurt -10")
	if body.has_method("take_damage"):
		body.take_damage(10)
