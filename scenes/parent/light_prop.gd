extends StaticBody2D

var broken: bool = false

func _ready():
	$PointLight2D.color = modulate

func hit(_damage):
	if not broken:
		$BreakSound.play(0.2)
		$Sprite2D.modulate = Color(0.1, 0.1, 0.1)
		turn_off()
		broken = true

func turn_on() -> void:
	$PointLight2D.enabled = true

func turn_off() -> void:
	$PointLight2D.enabled = false
