## a weapon, which can be held by a character
class_name Weapon
extends Equipment

@export var projectile: PackedScene

signal fired(proj: Projectile)

func execute_use():
	var proj = projectile.instantiate()
	proj.global_position = %SpawnPoint.global_position
	proj.rotation = global_rotation
	fired.emit(proj)
	
