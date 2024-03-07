class_name Equipment
extends Node2D

## the amount of time in seconds that the equipment will have to wait
@export var cooldown: float

func _ready():
	%UseCooldown.wait_time = cooldown

func can_use() -> bool:
	return %UseCooldown.is_stopped()

func use() -> void:
	if can_use():
		execute_use()

func execute_use() -> void:
	pass
