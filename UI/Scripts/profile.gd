extends Control



func _process(delta):
	get_node("stats_label").text = "
	Player Health: %s
	Player Attack: %s
	Player Defense: %s
	Player Level: %s
	Player EXP: %s / %s
	
	
	" %[PlayerData.player_health, PlayerData.main_hand_equipped.item_damage, PlayerData.armor_equipped.item_defense, PlayerData.player_level, PlayerData.current_exp, PlayerData.exp_to_next_level]
	
	
