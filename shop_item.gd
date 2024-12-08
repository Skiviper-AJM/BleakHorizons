extends Panel


var item_info: ItemData



func _on_button_pressed() -> void:
	get_node("../../").current_item = item_info
	$"../../item_info".show()
	$"../../item_info/item_name".text = item_info.item_name
	$"../../item_info/item_desc".text = "Stats: \n%s Damage\n%s Defense\n%s Health" % [item_info.item_damage, item_info.item_defense,item_info.item_health]
	$"../../item_info/item_sprite".texture = item_info.item_texture
