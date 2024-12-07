extends Node3D



var camroot_h = 0
var camroot_v = 0
@export var cam_v_max = 75
@export var cam_v_min = -55
var h_sensitivity: float = 0.01
var v_sensitivity: float = 0.01
var h_acceleration: float = 10.0
var v_acceleration: float = 10.0


@export var cam_max_zoom = -5 #maximum zoom in value
@export var cam_min_zoom = -10 #controls max distance of cam to player - is also the default zoom
@export var cam_default_zoom = -6
@onready var current_zoom = cam_default_zoom #logs the 'current' zoom value to the minimum, which is also the default, on start



# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	get_node("h/v").spring_length = cam_default_zoom #sets the spring length to the minimum zoom level at startup
	
	Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED) #captures future mouse inputs

func _input(event: InputEvent) -> void:
	if event is InputEventMouseMotion:
		camroot_h += -event.relative.x * h_sensitivity
		camroot_v += event.relative.y * v_sensitivity
	
	if event is InputEventMouseButton:
		if Input.is_action_pressed("CameraZoomIn"):
			current_zoom += 1 #zoom in
			#print("Zoom is at" + str(current_zoom))
		elif Input.is_action_pressed("CameraZoomOut"):
			current_zoom -= 1 #zoom out
			#print("Zoom is at" + str(current_zoom))
	
	

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _physics_process(delta: float) -> void:
	camroot_v = clamp(camroot_v, deg_to_rad(cam_v_min), deg_to_rad(cam_v_max)) #limits cam speed between max and min
	get_node("h").rotation.y = lerpf(get_node("h").rotation.y, camroot_h, delta*h_acceleration)
	get_node("h/v").rotation.x = lerpf(get_node("h/v").rotation.x, camroot_v, delta*v_acceleration)
	
	current_zoom = clamp(current_zoom, cam_min_zoom+1, cam_max_zoom+1) #limits camera zoo between max and min (+1 to prevent overspill)
	get_node("h/v").spring_length = current_zoom #ties camera spring arm to the set zoom amount 
