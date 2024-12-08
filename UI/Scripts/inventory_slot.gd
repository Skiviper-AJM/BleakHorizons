class_name InventorySlot
extends PanelContainer

@export var type: ItemData.Type

func init(t: ItemData.Type, cms: Vector2) -> void:
	type = t
	custom_minimum_size = cms


func _can_drop_data(at_position: Vector2, data: Variant) -> bool:
	if data is InventoryItem:
		if type == ItemData.Type.MAIN:
			if get_child_count() == 0:
				return true
			else:
				if type == data.get_parent().type:
					return true
				return get_child(0).data.type == data.data.type
		else:
			return data.data.type == type
	else:
		return false
	
func _drop_data(at_position: Vector2, data: Variant) -> void:
	if get_child_count() > 0:
		var item := get_child(0)
		if item == data:
			return
		item.reparent(data.get_parent())
	data.reparent(self) 

func _physics_process(delta: float) -> void:
	if get_child_count() > 0:
		var item := get_child(0)
		
		#this is how you set the equipped items, can scale to other slots
		if type == ItemData.Type.WEAPON:
			PlayerData.main_hand_equipped = item.data
		else:
			PlayerData.main_hand_equipped =load("res://UI/Inventory/Item Resources/default_sword.tres")
	

func _gui_input(event: InputEvent) -> void:
	if event is InputEventMouseButton:
		if Input.is_action_pressed("Block"):
			if get_child_count() > 0:
				#drink healing potion if you clicked it
				if (get_child(0).data.type == ItemData.Type.HPOTION):
					PlayerData.heal_player(get_child(0).data.item_health) #heals player by value of used healing flask when right clicked
					get_child(0).data.count -= 1
					get_child(0).get_child(0).text = str(get_child(0).data.count)
					if get_child(0).data.count <= 0:
						get_child(0).queue_free()