class_name BloodDecal
extends Node2D

var max_size: float = 1.0

func _ready():
	scale = Vector2(0.1,0.1)
	var tween = create_tween()
	tween.tween_property(self, "scale", Vector2(max_size, max_size), 8*max_size)
	tween.tween_property(self, "modulate", Color(0.15*randf_range(0.9,1.10), 
			0.15*randf_range(0.9,1.10), 
			0.15*randf_range(0.9,1.10)), 
			20)
	#tween.tween_property(self, "modulate", Color(0.5*randf_range(0.9,1.10), 0, 0), 20)

func set_blood_type(blood_type: BloodDecalSpawner.BLOOD_TYPE) -> void:
	if blood_type == BloodDecalSpawner.BLOOD_TYPE.enemy:
		$UpperDecal.modulate = Color(1, 0, 0.024)
		$LowerDecal.modulate = Color(0.5, 0, 0.024) # this may look bad
	elif blood_type == BloodDecalSpawner.BLOOD_TYPE.player:
		$UpperDecal.modulate = Color(0.039, 0.306, 1)
		$LowerDecal.modulate = Color(0.039, 0.15, 0.8)
