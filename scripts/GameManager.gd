extends Node


func _ready():
	pass # Replace with function body.

func _input(event):
	if event.is_action_pressed("quit"):
		get_tree().quit()