extends Node2D
const LEVEL1: PackedScene = preload("res://Scenes/village.tscn")
const LEVEL2: PackedScene = preload("res://Scenes/graveyard.tscn")
var NewLevelInstantiate
var current_level = null
#var NewLevelInstantiate

func _ready() -> void:
	current_level = LEVEL1.instantiate()
	add_child(current_level)
	var transition_controller = current_level.get_node("Transition_Controller")
	if transition_controller:
		print("Found transition controller")
		transition_controller.connect("level_change_request", initialize_level)

func initialize_level(target_level):
	print("signal received at director")
	var NewLevel = ResourceLoader.load(target_level)
	NewLevelInstantiate = NewLevel.instantiate()
	$Timer.start(0.5)

func load_new_level() -> void:
	add_child(NewLevelInstantiate)
	var transition_controller = NewLevelInstantiate.get_node("Transition_Controller")
	if transition_controller:
		print("Found transition controller")
		transition_controller.connect("level_change_request", initialize_level)
	if current_level:
		remove_child(current_level)
	current_level = NewLevelInstantiate


func _on_timer_timeout() -> void:
	load_new_level()
	var game_over_ui = preload("res://Scenes/game_over.tscn").instantiate()
	get_tree().root.add_child(game_over_ui)
