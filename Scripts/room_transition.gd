extends Area2D
@export var target_level = "res://Scenes/graveyard.tscn"

signal change_level(target_level)

func _on_body_entered(body: Node2D) -> void:
	emit_signal("change_level", target_level)
	print("Signal received")
	queue_free()
