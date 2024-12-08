extends Node

var state = {
	"Idle": preload("res://Enemies/Scripts/AI Ranged/IdleState.gd"),
	"Run": preload("res://Enemies/Scripts/AI Ranged/RunState.gd"),
	"Attack": preload("res://Enemies/Scripts/AI Ranged/AttackState.gd"),
	"Death": preload("res://Enemies/Scripts/AI Ranged/DeathState.gd") ,
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
