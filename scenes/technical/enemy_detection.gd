class_name EnemyDetection
extends Node2D

@export var enemy_group: String

signal enemy_spotted(body: Character)
signal enemy_entered_stealth_area(body: Character)
signal enemy_exited_agression_area(body: Character)

## casts a ray to determine if there is line of sight to the body
func has_line_of_sight(body) -> bool:
	$LineOfSightCheck.target_position = to_local(body.position)
	$LineOfSightCheck.force_raycast_update()
	
	if $LineOfSightCheck.get_collider() == null:
		print("Line of sight null (this is a problem)")
	
	return $LineOfSightCheck.get_collider() == body

func _on_stealth_area_body_entered(body) -> void:
	if body.is_in_group(enemy_group):
		enemy_entered_stealth_area.emit(body)

func _on_vision_area_body_entered(body) -> void:
	if not has_line_of_sight(body):
		return
	if body.is_in_group(enemy_group):
		enemy_spotted.emit(body as Character)

func _on_aggression_area_body_exited(body) -> void:
	if body.is_in_group(enemy_group):
		enemy_exited_agression_area.emit(body)
