extends Node

var inventory : Dictionary = {}

func add_inventory_item(item : Area2D):
	inventory[item.name] = item
	#print("Adding inventory item: ", inventory)

func check_item_in_inventory(item : String) -> bool:
	if inventory.has(item):
		#print("Found item in inventory")
		return true
	else:
		#print("Item not Found in inventory")
		return false
