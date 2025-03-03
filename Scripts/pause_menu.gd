extends CanvasLayer

@onready var pause_menu = $Control  # Reference to the UI
var is_paused: bool = false  # Tracks if the game is paused

func _ready():
	self.hide()

func _input(event):
	if event.is_action_pressed("Pause"):  # Press P 
		toggle_pause()

func toggle_pause():
	if is_paused:
		is_paused = false
		self.hide()
		get_tree().paused = false  # Pause/unpause game logic
	else:
		is_paused = true
		self.show()
		get_tree().paused = true  # Pause/unpause game logic
	
	
	#pause_menu.visible = is_paused  # Show/hide pause menu


func _on_resume_button_pressed():
	toggle_pause()  # Resume game when the button is clicked


func _on_quit_button_pressed():
	get_tree().quit()  # Exit game
