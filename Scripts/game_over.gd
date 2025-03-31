extends CanvasLayer
@onready var player = get_tree().get_first_node_in_group("player")
@onready var fade_duration = 1.5

# Called when the node enters the scene tree for the first time.
func _ready():
	self.hide()
	if player:
		player.has_died.connect(show_game_over)  # Listen for player's death
	#if player.has_dead == true:
		#show_game_over()
		
#	self.modulate.a = 0  # Start fully invisible


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass
#func show_game_over():
#	var tween = create_tween()
#	tween.tween_property(self, "modulate:a", 1, fade_duration).set_trans(Tween.TRANS_SINE).set_ease(Tween.EASE_IN_OUT)

func show_game_over():
	self.show()  # Make it visible
	$AnimationPlayer.play("fade_in")
#	$AnimationPlayer.play("fade_in")  # Play fade-in animation


func _on_give_up_pressed():
	get_tree().quit()  # Quits the game


func _on_try_again_pressed():
	Engine.time_scale = 1
	get_tree().reload_current_scene()  # Reloads the current game scene
