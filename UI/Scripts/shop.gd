extends CanvasLayer

@onready var shop_item = preload("res://UI/Scenes/shop_item.tscn")
var current_item: ItemData
func _ready() -> void:
	for i in PlayerData.items:
		if i != "default":
			var shop_item_temp = shop_item.instantiate()
			shop_item_temp.item_info = PlayerData.items[i]
			shop_item_temp.get_node("image").texture = PlayerData.items[i].item_texture
			$shop_items.add_child(shop_item_temp)
	$item_info.hide()


func _on_buy_pressed() -> void:
	get_node("../container/Inventory").add_item(str(get_node("item_info/item_name").text))


func _on_close_pressed() -> void:
	self.hide()
