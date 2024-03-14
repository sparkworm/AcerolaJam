class_name BloodDecalSpawner
extends CharacterBody2D

enum BLOOD_TYPE{
	enemy,
	player,
}

var initial_v: float
var blood_type: BLOOD_TYPE

signal spawn_blood_decal(pos: Vector2, initial_velocity: float, type: BLOOD_TYPE)

func _ready():
	pass

func _process(delta):
	# find a more efficient way to do this
	velocity = velocity / (1+(5*delta))
	
	if velocity.length() <= 5:
		spawn_blood_decal.emit(global_position, initial_v, blood_type)
		queue_free()
	
	move_and_slide()

func set_blood_type(type: BLOOD_TYPE) -> void:
	blood_type = type
	if type == BLOOD_TYPE.enemy:
		$Sprite2D.modulate = Color(1, 0, 0.024)
	elif type == BLOOD_TYPE.player:
		$Sprite2D.modulate = Color(0.039, 0.306, 1)
