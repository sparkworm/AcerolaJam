class_name EnemyDetection
extends Node2D

@export var enemy_group: String

signal enemy_spotted(body: Character)
signal enemy_entered_stealth_area(body: Character)
signal enemy_exited_agression_area(body: Character)

func _on_stealth_area_body_entered(body):
	print("body entered stealth")
	if body.is_in_group(enemy_group):
		enemy_entered_stealth_area.emit(body)

func _on_vision_area_body_entered(body):
	print("body entered vision")
	if body.is_in_group(enemy_group):
		enemy_spotted.emit(body as Character)

func _on_aggression_area_body_exited(body):
	enemy_exited_agression_area.emit(body)
