extends Area2D

@export var health_value = 15

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass
	

func _on_body_entered(body):
	if body.is_in_group("player"):
		print("Health potion triggered by:", body.name)  # Debugging
		self.hide()
		$AudioStreamPlayer2D.stop() 
		$AudioStreamPlayer2D.play()
		body.restore_health(health_value)
		await $AudioStreamPlayer2D.finished
		queue_free() 
