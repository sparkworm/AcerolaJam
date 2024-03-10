## a weapon, which can be held by a character
class_name Weapon
extends Equipment

@export var projectile: PackedScene
@export var fire_effect: PackedScene

signal fired(proj: Projectile)

func execute_use() -> void:
	spawn_projectile()
	spawn_fire_effect()
	

func spawn_projectile() -> void:
	var proj = projectile.instantiate()
	proj.global_position = %SpawnPoint.global_position
	proj.rotation = global_rotation
	fired.emit(proj)

func spawn_fire_effect() -> void:
	var effect = fire_effect.instantiate()
	effect.position = %SpawnPoint.position
	add_child(effect)
	effect.activate()
