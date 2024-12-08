extends Control



@export var inventory_size = 24

@onready var grid = get_node("grid")

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	for i in range(inventory_size):
		var slot = InventorySlot.new()
		slot.init(ItemData.Type.MAIN, Vector2(32,32))
		get_node("grid").add_child(slot)
	add_item("body armor")


func add_item(item_name: String) -> void:
	var item = InventoryItem.new()
	item.init(PlayerData.items[item_name])
	if item.data.stackable:
		# Check if we already have the item
		for i in inventory_size:
			if grid.get_child(i).get_child_count() > 0:
				# This means the slot has an item, now we check if the item is the same
				if grid.get_child(i).get_child(0).data == item.data:
					# Add to data count
					grid.get_child(i).get_child(0).data.count += 1
					# Update label counter
					grid.get_child(i).get_child(0).get_child(0).text = str(grid.get_child(i).get_child(0).data.count)
					break
			else:
				#couldnt find item in inventory, so we create it. only stackable items
				grid.get_child(i).add_child(item)
				break
	else:
		# Find empty slot
		for i in inventory_size:
			if grid.get_child(i).get_child_count() == 0:
				grid.get_child(i).add_child(item)
				break
