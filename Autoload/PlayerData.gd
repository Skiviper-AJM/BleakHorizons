extends Node

var player_health: int = 10
var player_max_health: int = 10

var main_hand_equipped: ItemData

func heal_player(amount):
	player_health += amount
	if player_health > player_max_health:
		player_health = player_max_health #prevents overheal
