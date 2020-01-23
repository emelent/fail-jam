extends Node2D

# Declare member variables here. Examples:
# var a = 2
# var b = "text"

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	handle_input()
	pass

func handle_input():
	if Input.is_action_pressed("dive"):
		rotation_degrees += 1
	if Input.is_action_pressed("rise"):
		rotation_degrees -= 1
	pass
