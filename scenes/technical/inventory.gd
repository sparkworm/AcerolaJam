## class designed to hold children items, only displaying the one in use.
class_name Inventory
extends Node2D

@onready var slots_dict = {
	Equipment.ITEM_CATAGORIES.melee_weapon : %Melee,
	Equipment.ITEM_CATAGORIES.ranged_weapon : %Ranged,
}

@onready var default_children := [%Melee, %Ranged]

var item_held: Equipment = null

## emitted when an item is removed allowing the level to spawn in an item pickup
signal item_removed(item:Equipment, coords: Vector2)

func _ready():
	catagorize_outside_items()

#region initialization

## this brings all outside items (items placed as children of inventory) in their 
## respective catagory
func catagorize_outside_items() -> void:
	for child in get_children():
		if child != null and child not in default_children:
			child = child as Equipment
			add_item(child)

#endregion

## adds a specified item to its corrosponding slot
## [br] will replace an existing item, if present
func add_item(item: Equipment) -> void:
	# removes any existing items
	remove_item(item.item_catagory)
	# adds item
	item.reparent(slots_dict[item.item_catagory])
	#slots_dict[item.item_catagory].add_child(item)

## removes all items in a given slot, though there shouldn't be more than one in a slot
func remove_item(idx:Equipment.ITEM_CATAGORIES) -> void:
	var slot:Node2D = slots_dict[idx]
	for child in slot.get_children(): # should never be more than one, but looped anyway
		slot.remove_child(child)
		item_removed.emit(child, global_position)

## this is the function called from outside to change the held item
func change_item_held(idx: Equipment.ITEM_CATAGORIES)-> void:
	if slots_dict[idx].get_child_count() > 0:
		set_item_held(slots_dict[idx].get_child(0))
	else:
		unset_item_held()

## this is only called within inventory by change_item_held()
func set_item_held(item: Equipment) -> void:
	unset_item_held()
	item_held = item
	item_held.show()

func unset_item_held() -> void:
	if item_held != null:
		item_held.hide()
		item_held = null

func use_item() -> void:
	if item_held != null:
		item_held.use()

func get_all_items() -> Array[Equipment]:
	var arr: Array[Equipment] = []
	for slot in get_children():
		if slot.get_child_count() > 0:
			arr.append(slot.get_child(0))
	return arr
