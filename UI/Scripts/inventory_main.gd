extends Control


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	var slot = InventorySlot.new()
	add_child(slot)
