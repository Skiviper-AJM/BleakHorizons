extends Area3D




func _on_animation_player_animation_finished(anim_name: StringName) -> void:
	$Mage/AnimationPlayer.play("Idle")

func _on_body_entered(body: Node3D) -> void:
	if body.is_in_group("player"):
		get_node("../../GUI/shop").show()
		Input.mouse_mode = Input.MOUSE_MODE_VISIBLE
		get_tree().paused = true


func _on_body_exited(body: Node3D) -> void:
	if body.is_in_group("player"):
		get_node("../../GUI/shop").hide()
		Input.mouse_mode = Input.MOUSE_MODE_CAPTURED
		get_tree().paused = false
