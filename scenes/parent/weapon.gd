## a weapon, which can be held by a character
class_name Weapon
extends Equipment

@export var projectile: Projectile

signal fired(proj: Projectile)

func execute_use():
	pass
