extends Area3D


var rng: int

func _ready():
	var tween = create_tween()
	var rng_position = Vector3(randi_range(-1,1), 1, randi_range(-1,1))
	tween.tween_property(self, "position", position + rng_position, 0.2)
	rng = randi_range(0,1)
	
	match rng:
		0:
			get_node("long sword").show()
			get_node("HPotion").hide()
		1:
			get_node("long sword").hide()
			get_node("HPotion").show()
			
func _on_body_entered(body):
	if body.is_in_group("player"):
		self.hide()
		match rng:
			0:
				get_node("../../GUI/container/Inventory").add_item("long sword")
			1:
				get_node("../../GUI/container/Inventory").add_item("small potion")


func _on_pickup_finished():
	self.queue_free()
