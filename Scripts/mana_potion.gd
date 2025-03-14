extends Area2D

@export var mana_value = 10

# Called when the node enters the scene tree for the first time.
func _ready():
	pass


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass
	

func _on_body_entered(body):
	if body.is_in_group("player"):
		print("Mana potion triggered by:", body.name)  # Debugging
		self.hide()
		$AudioStreamPlayer2D.stop() 
		$AudioStreamPlayer2D.play()
		body.restore_mana(mana_value)
		await $AudioStreamPlayer2D.finished  # Wait for the sound to finish
		queue_free() 
