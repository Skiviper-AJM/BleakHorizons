extends Node

var AIController
var run:bool = false


func _ready() -> void:
	AIController = get_parent().get_parent()
	if AIController.Attacking:
		await AIController.get_node("AnimationTree").finished_animation
	else:
		AIController.get_node("AnimationTree").get("parameters/playback").travel("Awaken")
		AIController.Awakening = true
		await AIController.get_node("AnimationTree").finished_animation
	run = true
	AIController.Awakening = false
	AIController.get_node("AnimationTree").get("parameters/playback").travel("Run")
	
func _physics_process(delta: float) -> void:
	if AIController:
		AIController.velocity.x = 0
		AIController.velocity.z = 0 
