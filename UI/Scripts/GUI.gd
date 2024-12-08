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
	
	



func _on_invetory_button_pressed():
	get_node("container/VBoxContainer/invetory_button").disabled = true
	get_node("container/VBoxContainer/profile_button").disabled = false
	get_node("container/Inventory").show()
	get_node("container/Profile").hide()

func _on_profile_button_pressed():
	get_node("container/VBoxContainer/invetory_button").disabled = false
	get_node("container/VBoxContainer/profile_button").disabled = true
	get_node("container/Inventory").hide()
	get_node("container/Profile").show()


