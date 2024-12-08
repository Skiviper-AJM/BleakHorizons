extends CharacterBody3D


const SPEED = 1.0


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


func _on_just_hit_timeout():
	just_hit = false


func _on_chase_player_detection_body_entered(body):
	if "player" in body.name and !dying:
		state_controller.change_state("Run")

func _on_chase_player_detection_body_exited(body):
	if "player" in body.name and !dying:
		state_controller.change_state("Idle")

func _on_attack_player_detection_body_entered(body):
	if "player" in body.name and !dying:
		state_controller.change_state("Attack")

func _on_attack_player_detection_body_exited(body):
	if "player" in body.name and !dying:
		state_controller.change_state("Run")


func _on_animation_tree_animation_finished(anim_name):
	if anim_name == "Awaken":
		Awakening = false
	elif anim_name == "Attack":
		Attacking = false
		state_controller.change_state("Run")
	elif anim_name == "Death":
		self.queue_free()

