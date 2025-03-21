extends PathFollow2D

@export var speed: float = 65.0
var moving: bool = true

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	if moving:  # Only move if 'moving' is true
		progress += speed * delta
