extends Node2D
signal level_change_request(target_level)

func _on_room_transition_change_level(target_level: Variant) -> void:
	request_level_change(target_level)
func request_level_change(target_level):
	emit_signal("level_change_request", target_level)
	print("signal sent")
