extends CanvasLayer


# Called when the node enters the scene tree for the first time.
func _ready():
	self.hide()


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass


func _on_give_up_pressed():
	get_tree().quit()  # Quits the game


func _on_try_again_pressed():
	get_tree().reload_current_scene()  # Reloads the current game scene
