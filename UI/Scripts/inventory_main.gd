extends Control



var items_to_load = [
	"res://UI/Inventory/Item Resources/small potion.tres",
	"res://UI/Inventory/Item Resources/long Sword.tres"
]

@onready var grid = get_node("grid")

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	for i in range(24):
		var slot = InventorySlot.new()
		slot.init(ItemData.Type.MAIN, Vector2(32,32))
		get_node("grid").add_child(slot)
	for i in items_to_load.size():
		var item = InventoryItem.new()
		item.init(load(items_to_load[i]))
		grid.get_child(i).add_child(item)
