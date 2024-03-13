extends StaticBody2D

func _ready():
	$PointLight2D.color = modulate

func hit(_damage):
	turn_off()

func turn_on() -> void:
	$PointLight2D.enabled = true

func turn_off() -> void:
	$PointLight2D.enabled = false