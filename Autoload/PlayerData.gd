extends Node



var items = {
	"default": preload("res://UI/Inventory/Item Resources/default_sword.tres"),
	"long sword": preload("res://UI/Inventory/Item Resources/long Sword.tres"),
	"small potion": preload("res://UI/Inventory/Item Resources/small potion.tres"),
	"body armor": preload("res://UI/Inventory/Item Resources/body armor.tres"),
	
}

var player_health: int = 10
var player_max_health: int = 10

var main_hand_equipped: ItemData
var armor_equipped: ItemData

var player_damage: int = 0 
var player_defense: int = 0

var current_exp: int = 0
var exp_to_next_level: int = 100
var player_level: int = 1

func heal_player(amount):
	player_health += amount
	if player_health > player_max_health:
		player_health = player_max_health #prevents overheal

func gain_exp(exp_amount: int):
	current_exp += exp_amount
	while current_exp >= exp_to_next_level:
		#level up
		player_level += 1
		current_exp -= exp_to_next_level
		exp_to_next_level = round(exp_to_next_level*1.3)
		exp_to_next_level = exp_to_next_level* pow(1.2, player_level - 1)
