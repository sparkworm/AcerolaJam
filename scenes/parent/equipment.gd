class_name Equipment
extends Node2D

func can_use() -> bool:
	return %UseCooldown.is_stopped()

func use() -> void:
	pass
