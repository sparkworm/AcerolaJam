## class designed to hold children items, only displaying the one in use.
class_name Inventory
extends Node2D

var slots_dict = {
	Equipment.ITEM_CATAGORIES.melee_weapon : %Melee,
	Equipment.ITEM_CATAGORIES.ranged_weapon : %Ranged,
}

## emitted when an item is removed allowing the level to spawn in an item pickup
signal item_removed(item:Equipment, coords: Vector2)

## adds a specified item to its corrosponding slot
## [br] will replace an existing item, if present
func add_item(item: Equipment) -> void:
	# removes any existing items
	remove_item(item.item_catagory)
	# adds item
	slots_dict[item.item_catagory].add_child(item)

## removes all items in a given slot, though there shouldn't be more than one in a slot
func remove_item(idx:Equipment.ITEM_CATAGORIES) -> void:
	var slot:Node2D = slots_dict[idx]
	for child in slot.get_children(): # should never be more than one, but looped anyway
		slot.remove_child(child)
		item_removed.emit(child, global_position)
