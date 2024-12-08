extends CanvasLayer


# Called when the node enters the scene tree for the first time.
func _ready():
	#hide by default
	self.hide()

func _on_retry_pressed() -> void:
	PlayerData.player_health = PlayerData.player_max_health
	get_tree().paused = false
	get_tree().reload_current_scene()
	
func game_over() -> void:
	Input.mouse_mode = Input.MOUSE_MODE_VISIBLE
	self.show()
	get_tree().paused = true
	
