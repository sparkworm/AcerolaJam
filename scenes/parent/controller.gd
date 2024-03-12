## This class controls a character
class_name Controller
extends Node

@export var character: Character

signal move(direction: Vector2)
signal rotate(target_direction: float, delta: float)
## an action MUST correspond with a piece of Equipment
signal use_item()
signal change_item(idx: Equipment.ITEM_CATAGORIES)
signal drop_item()
signal grab_item()

func calculate_movement(_delta) -> void:
	pass

func calculate_rotation(_delta) -> void:
	pass
