## class designed to hold children items, only displaying the one in use.
class_name Inventory
extends Node2D

enum SLOTS {
	none,
	melee,
	ranged,
}



## the item that is currently held.  If equal to -1, then no item is held
var selected_item_index := -1
var selected_item: Node = null

func _ready():
	for child in get_children():
		child.hide()
	

func select_item(idx:SLOTS):
	get_child(selected_item_index).hide()
	get_child(idx).show

func use_item() -> void:
	get_child(selected_item).use()

func has_selected_item() -> bool:
	return false
