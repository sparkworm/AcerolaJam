class_name WeaponDrop
extends CharacterBody2D

var weapon: Weapon

func _process(delta):
	move_and_slide()
	velocity = velocity / (1+(4*delta))
	rotation += velocity.length()*0.1*delta

func add_weapon(w: Weapon) -> void:
	$Weapon.add_child(w)
	w.show()
	#w.reparent($Weapon)

func get_weapon() -> Weapon:
	return $Weapon.get_child(0)
