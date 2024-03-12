class_name BloodDecal
extends Node2D

var max_size: float = 1.0

func _ready():
	scale = Vector2(0.1,0.1)
	var tween = create_tween()
	tween.tween_property(self, "scale", Vector2(max_size, max_size), 8*max_size)
	tween.tween_property(self, "modulate", Color(0.5*randf_range(0.9,1.10), 0, 0), 20)
			#set_trans(Tween.TRANS_QUAD)
