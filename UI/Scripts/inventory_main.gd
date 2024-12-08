extends Control



@export var inventory_size = 24

@onready var grid = get_node("grid")

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	for i in range(inventory_size):
		var slot = InventorySlot.new()
		slot.init(ItemData.Type.MAIN, Vector2(32,32))
		get_node("grid").add_child(slot)
	


func add_item(item_name:String) -> void:
	var item = InventoryItem.new()
	item.init(PlayerData.items[item_name])
	if item.data.stackable:
		for i in inventory_size:
			if grid.get_child(0).get_child_count() > 0:
				if grid.get_child(i).get_child(0).data == item.data:
					#updates counter
					grid.get_child(i).get_child(0).data.count += 1
					#label counter
					grid.get_child(i).get_child(0).get_child(0).text = str(grid.get_child(i).get_child(0).data.count)
					break
			else:
				grid.get_child(i).add_child(item)
				break
	else:
		for i in inventory_size:
			if grid.get_child(0).get_child_count() == 0:
				grid.get_child(i).add_child(item)
				break
