extends CharacterBody3D


const SPEED = 5.0
const JUMP_VELOCITY = 4.5

# Get the gravity from the project settings to be synced with RigidBody nodes.
var gravity = ProjectSettings.get_setting("physics/3d/default_gravity")

@onready var state_controller = get_node("StateMachine")
@export var player: CharacterBody3D

var direction: Vector3
var Awakening:bool = false
var Attacking:bool = false
var health:int = 4
var damage:int = 2
var dying: bool = false
var just_hit:bool = false

func _ready() -> void:
	state_controller.change_state("Idle")

func _physics_process(delta):
	# Add the gravity.
	if not is_on_floor():
		velocity.y -= gravity * delta
	
	if player:
		direction = (player.global_transform.origin - self.global_transform.origin)
	print(direction)
	move_and_slide()
