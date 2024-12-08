extends CanvasLayer


func _ready() -> void:
	get_node("container").visible = get_tree().paused

func _physics_process(delta: float) -> void:
	if Input.is_action_just_pressed("OpenInventory"):
		get_tree().paused = !get_tree().paused
		get_node("container").visible = get_tree().paused
		match get_tree().paused:
			true:
				Input.mouse_mode = Input.MOUSE_MODE_VISIBLE
			false:
				Input.mouse_mode = Input.MOUSE_MODE_CAPTURED
	
	
