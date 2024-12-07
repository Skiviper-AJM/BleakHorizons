extends CharacterBody3D


@onready var animation_tree = get_node("AnimationTree")
@onready var playback = animation_tree.get("parameters/playback")

@onready var player_mesh = get_node("Knight") #sets mesh to knights node so the whole character doesnt rotate, prevents weird camera jank


@export var gravity: float = 9.8
@export var jump_force: int = 9
@export var walk_speed: int = 3
@onready var run_speed: int = (walk_speed * 3) #run speed is automatically set to tripple the walk speed

#anim node names
var idle_node_name:String = "Idle"
var walk_node_name:String = "Walk"
var run_node_name:String = "Run"
var jump_node_name:String = "Jump"
var attack1_node_name:String = "Attack1"
var death_node_name:String = "Death_A"

#state machine
var is_attacking: bool
var is_walking: bool
var is_running: bool
var is_dying: bool

#physics vals
var direction: Vector3
var horizontal_velocity: Vector3
var aim_turn: float
var movement: Vector3
var vertical_velocity: Vector3
var movement_speed: int
var angular_acceleration: int
var acceleration: int
var just_hit:bool = false

@onready var camrot_h = get_node("camroot/h")

func _ready() -> void:
	
	direction = Vector3.BACK.rotated(Vector3.UP, camrot_h.global_transform.basis.get_euler().y)

func _input(event: InputEvent) -> void:
	if event is InputEventMouseMotion:
		aim_turn = -event.relative.x * 0.15
	
	# controls aiming ranged weapons - add a tag to check if its a ranged weapon!
	if event.is_action_pressed("LockOn"): #aim
		direction = camrot_h.global_transform.basis.z
	
	
func _physics_process(delta: float) -> void:
	if !is_dying:
		#test values
		angular_acceleration = 10
		movement_speed = 0
		acceleration = 15
		var h_rot = camrot_h.global_transform.basis.get_euler().y
		#handles WASD directional input
		if (Input.is_action_pressed("MoveForward") || Input.is_action_pressed("MoveBack") || Input.is_action_pressed("MoveLeft") || Input.is_action_pressed("MoveRight")):
			#subtracts opposing directions by each other when pressed simultaniously to prevent moving 
			direction = Vector3(Input.get_action_strength("MoveLeft") - Input.get_action_strength("MoveRight"), 
						0,
						Input.get_action_strength("MoveForward") - Input.get_action_strength("MoveBack"))
			direction = direction.rotated(Vector3.UP, h_rot).normalized()
		
		if Input.is_action_pressed("LockOn"): #aim
			player_mesh.rotation.y = lerp_angle(player_mesh.rotation.y, camrot_h.rotation.y, delta*angular_acceleration)
		else: 
			player_mesh.rotation.y = lerp_angle(player_mesh.rotation.y, atan2(direction.x, direction.z) - rotation.y, delta*angular_acceleration)
