extends Node2D

var circles = []
export var sonar_radius = 96.0
export var sonar_scale_weight = 0.05
export var sonar_outline = 20

func _ready():
#	$Background.color = Color.black
	pass

func _input(event):
	if event.is_action_pressed("dive"):
		$Beep.play()
		create_circle()
	if event.is_action_pressed("rise"):
		$Beep.play()
		create_circle2()

func _draw():
	for circle in circles:
		# draw circle
		if circle.outline == -1:
			draw_circle(circle.position, circle.radius, circle.color)
		else:
			draw_circle_arc(circle.position, circle.radius, 0, 360, circle.color, circle.outline)
		if circle.radius >= sonar_radius:
			circles.erase(circle)
			print("removing")
		pass

func _process(delta):
	for i in range(circles.size()):
		update_circle(i)

func draw_circle_arc(center, radius, angle_from, angle_to, color, width):
    var nb_points = 64
    var points_arc = PoolVector2Array()

    for i in range(nb_points + 1):
        var angle_point = deg2rad(angle_from + i * (angle_to-angle_from) / nb_points - 90)
        points_arc.push_back(center + Vector2(cos(angle_point), sin(angle_point)) * radius)

    for index_point in range(nb_points):
        draw_line(points_arc[index_point], points_arc[index_point + 1], color, width)

func update_circle(i):
	circles[i].radius = lerp(circles[i].radius, sonar_radius, sonar_scale_weight)
	circles[i].color.a = lerp(circles[i].color.a, 0, sonar_scale_weight)
	if circles[i].outline != -1:
		circles[i].outline = lerp(circles[i].outline, 0, sonar_scale_weight)
	update()


func create_circle():
	circles.append({
		position =  get_global_mouse_position(),
		radius = 0.1,
		color = Color.green,
		opacity = 1,
		outline  = -1
	})

func create_circle2():
	circles.append({
		position =  get_global_mouse_position(),
		radius = 0.1,
		color = Color.green,
		opacity = 1,
		outline  = sonar_outline
	})

