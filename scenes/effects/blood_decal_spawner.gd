class_name BloodDecalSpawner
extends CharacterBody2D

signal spawn_blood_decal(pos: Vector2)

var initial_v: float

func _process(delta):
	# find a more efficient way to do this
	velocity = velocity / (1+(5*delta))
	
	if velocity.length() <= 5:
		spawn_blood_decal.emit(global_position, initial_v)
		queue_free()
	
	move_and_slide()
