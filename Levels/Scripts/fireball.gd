extends Area3D

var direction: Vector3
var speed: int = 1
var damage: int = 1
var owner_name: String = "player"

func _physics_process(delta:float) -> void:
	self.position += direction*speed*delta

func _on_body_entered(body):
	if body.is_in_group("player"):
		if "monster" in owner_name:
			body.hit(damage)
			self.queue_free()
