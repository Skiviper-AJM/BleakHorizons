extends Node


const SAVE_PATH: String = "res://savegame.bin"

func save_game() -> void: 
	var file = FileAccess.open(SAVE_PATH, FileAccess.WRITE)
	var data: Dictionary = {}
	var inventory = get_node("/root/MainLevel/GUI/container/Inventory")
	for i in inventory.getchild(0).get_child_count():
		if inventory.get_child(0).get_child(i).get_child_count() > 0:
			#slot has item
			var item_data = inventory.get_child(0).get_child(i).data
			data[item_data.item_name] = item_data.count
	
	var jstr = JSON.stringify(data)
	file.store_line(jstr)
func load_game() -> void:
	pass
