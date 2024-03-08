class_name Equipment
extends Node2D

## the amount of time in seconds that the equipment will have to wait
@export var cooldown: float = 1.0

var cooled_down: bool

func _ready():
	%UseCooldown.wait_time = cooldown
	cooled_down = true

func can_use() -> bool:
	return cooled_down

func use() -> void:
	if can_use():
		%UseCooldown.start()
		cooled_down = false
		execute_use()

func execute_use() -> void:
	pass

func _on_use_cooldown_timeout():
	cooled_down = true
