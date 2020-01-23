extends KinematicBody2D


export(float) var speed = 80
export(float) var turn_speed = 8
export(float, 0, 1) var acceleration = 0.05
export(float, 0, 1) var deceleration = 0.1
export(float, 0, 1) var decay = 0.005
export(float, 0, 1) var bounce = 0.15

onready var Thruster = $Thruster
onready var Artillery = $Artillery
onready var Body = $Body
onready var ThrusterParticles: CPUParticles2D = $Particles

var motion = Vector2.ZERO
var speed_locked = false
var mining = false

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.

func _input(_event):
	if Input.is_action_just_pressed("lock_speed"):
		speed_locked = !speed_locked
		ThrusterParticles.emitting = speed_locked
		if speed_locked:
			ThrusterParticles.explosiveness = 0.3
			$BubbleSound.stop()
			$BubbleSound.pitch_scale = 1.8
			$BubbleSound.play()

		else:
			ThrusterParticles.explosiveness = 0.16
			$BubbleSound.stop()

func _process(delta):
	$LabelSpeed.text = "SPEED: %s" % motion.length()
	if mining:
		$LabelSpeed.text = "MINING: %s" % $MineSound.playing

	if Input.is_action_pressed("accelerate") and not speed_locked:
		motion = lerp(motion, Vector2.UP.rotated(Thruster.rotation) * speed, acceleration)
		ThrusterParticles.emitting = true
		if not $BubbleSound.playing:
			$BubbleSound.pitch_scale = 2.1
			$BubbleSound.play()
	elif Input.is_action_just_released("accelerate") and not speed_locked:
		ThrusterParticles.emitting = false
		$BubbleSound.stop()
	if Input.is_action_pressed("decelerate"):
		motion = lerp(motion, Vector2.ZERO, deceleration)
		speed_locked = false
		ThrusterParticles.emitting = false
		$BubbleSound.stop()


	if Input.is_action_pressed("turn_left"):
		Thruster.rotation_degrees += turn_speed
		if speed_locked:
			motion = Vector2.UP.rotated(Thruster.rotation) * motion.length()
		pass
	elif Input.is_action_pressed("turn_right"):
		Thruster.rotation_degrees -= turn_speed
		if speed_locked:
			motion = Vector2.UP.rotated(Thruster.rotation) * motion.length()

	if Input.is_action_pressed("mine"):
		mining = true
		if not $MineSound.playing:
			$MineSound.pitch_scale = rand_range(0.31, 0.78)
			$MineSound.play()
	elif Input.is_action_just_released("mine"):
		$MineSound.stop()
		mining = false

	pass

func _physics_process(delta):
	if not speed_locked:
		motion = lerp(motion, Vector2.ZERO, decay)
	var collision = move_and_collide(motion * delta)
	if collision != null:
		motion = collision.normal * motion.length() * bounce
		speed_locked = false
		$BubbleSound.stop()
		ThrusterParticles.emitting = false


	ThrusterParticles.position = Thruster.position + (Thruster.offset.normalized().rotated(Thruster.rotation) * 40)
	ThrusterParticles.rotation = Thruster.rotation

	pass

