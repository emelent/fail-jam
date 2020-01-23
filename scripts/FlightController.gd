extends KinematicBody2D

onready var LblRotation = $LblRotation
onready var Graphic = $Graphic

var is_diving = false
var is_rising = false

var angle = 0
export(float, 0, 1) var dive_rotation_weight = 0.07
export(float, 0, 1) var undive_rotation_weight = 0.15

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.

#func _input(event):
#	if event.is_action_pressed("dive"):
#		print("pressssed")

func _process(delta):
	handle_input()
	handle_rotation()

	LblRotation.text = "ROTATION: %s" % angle
	pass


func handle_input():
	is_diving = Input.is_action_pressed("dive")
	is_rising = Input.is_action_pressed("rise")
	pass


func handle_rotation():

	## TODO use mathematical functions to set the
	# angle over time, so it's
	if is_diving && angle < 90:
		angle = lerp(angle, 90, dive_rotation_weight)
	elif is_rising && angle > -90:
		angle = lerp(angle, -30, dive_rotation_weight)
	elif angle != 0:
		angle = lerp(angle, 0, undive_rotation_weight)

	Graphic.set_rotation_degrees(angle)
	pass