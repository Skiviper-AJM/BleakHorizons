extends Node

var state = {
	"Idle": preload("res://Enemies/Scripts/AI Melee/IdleState.gd"),
	"Run": preload("res://Enemies/Scripts/AI Melee/RunState.gd"),
	"Attack": preload("res://Enemies/Scripts/AI Melee/AttackState.gd"),
	"Death": preload("res://Enemies/Scripts/AI Melee/DeathState.gd") ,
}

func _ready() -> void:
	change_state("Idle")
	

func change_state(new_state:String): 
	if get_child_count() != 0:
		get_child(0).queue_free()
		
	if state.has(new_state):
		var state_temp = state[new_state].new()
		state_temp.name = new_state
		add_child(state_temp)
