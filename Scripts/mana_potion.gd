extends Area2D

@export var mana_value = 10

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass
	

func _on_body_entered(body):
	if body.is_in_group("player"):
		$AudioStreamPlayer2D.play()
		body.restore_mana(mana_value)
		queue_free() 
