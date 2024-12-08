extends CanvasLayer


@onready var shop_item_scene:PackedScene = preload("res://UI/Scenes/shop_item.tscn")
var current_item: ItemData

func _ready() -> void:
	for i in PlayerData.items: 
		if i != "default":
			var shop_item_temp = shop_item_scene.instantiate()
			shop_item_temp.item_info = PlayerData.items[i]
			shop_item_temp.get_node("image").texture = PlayerData.items[i].item_texture
			get_node("shop_items").add_child(shop_item_temp)
	get_node("item_info").hide()

func _on_buy_pressed():
	get_node("../container/Inventory").add_item(str(current_item.item_name))


func _on_close_pressed():
	get_tree().paused = false
	self.hide()

