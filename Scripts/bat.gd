extends CharacterBody2D

var speed = 40
var direction: Vector2
var is_bat_chase: bool

func _on_timer_timeout():
	$Timer.wait_time = choose([0.5, 1, 1.5])

func  choose(array):
	array.shuffle()
	return array.front()
