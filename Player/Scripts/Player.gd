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
