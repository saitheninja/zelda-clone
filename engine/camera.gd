extends Camera2D

const SCREEN_SIZE = Vector2(160,128)
const HUD_THICKNESS = 16
# rooms are all placed on a grid, this keeps track of which chunk of room we're in
var grid_pos = Vector2(0,0)

# camera shake stuff
onready var timer = get_node("Timer")

export var amplitude : = 6.0
export var duration : = 0.8
export(float, EASE) var DAMP_EASING : = 1.0
export var enabled : = false
var shake : = false


func _ready():
	$area.connect("body_entered",self,"body_entered")
	$area.connect("body_exited",self,"body_exited")
	$area.connect("area_exited",self,"area_exited")
	set_duration(duration)
	connect_to_shakers()

func _process(delta):
	# get player position in room grid, set camera to same position
	var player_grid_pos = get_grid_pos(get_node("../player").global_position)
	global_position = player_grid_pos * SCREEN_SIZE
	grid_pos = player_grid_pos
	# camera shake stuff
	if shake:
		var damping : = ease(timer.time_left / timer.wait_time, DAMP_EASING)
		offset = Vector2(
			rand_range(amplitude, -amplitude) * damping,
			rand_range(amplitude, -amplitude) * damping)

# camera shake stuff
# turn camera shake off once duration is done, from Timer signal
func _on_Timer_timeout() -> void:
	set_shake(false)

# when signal is received, turn on shake
func _on_camera_shake_requested() -> void:
	print("signal received")
	if not enabled:
		return
	set_shake(true)

# set duration of camera shake
func set_duration(value: float) -> void:
	duration = value
	timer.wait_time = duration

# turns on shaker
func set_shake(value: bool) -> void:
	shake = value
	offset = Vector2()
	print(offset)
	if shake:
		timer.start()
		print(offset)
	
func connect_to_shakers() -> void:
	# connect emmiters to this receiver
	# emitters are all nodes in camera_shaker group
	for camera_shaker in get_tree().get_nodes_in_group("camera_shaker"):
		camera_shaker.connect("camera_shake_requested", self, "_on_camera_shake_requested")
			

func get_grid_pos(pos):
	# screen pos / screen size = no. of screens away
	pos.y -= HUD_THICKNESS
	var x = floor(pos.x / SCREEN_SIZE.x)
	var y = floor(pos.y / SCREEN_SIZE.y)
	return Vector2(x,y)

func get_enemies():
	var enemies = []
	# for all bodies overlapping camera2d area
	for body in $area.get_overlapping_bodies():
		# use get so it doesn't crash if there is no type
		if body.get("TYPE") == "ENEMY" && enemies.find(body) == -1:
			# add enemies to array if they aren't there
			enemies.append(body)
	return enemies.size()


func body_entered(body):
	if body.get("TYPE") == "ENEMY":
		body.set_physics_process(true)

func body_exited(body):
	if body.get("TYPE") == "ENEMY":
		body.set_physics_process(false)

func area_exited(area):
	if area.get("disappears") == true:
		area.queue_free()