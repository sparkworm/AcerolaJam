extends VisualEffect


func activate() -> void:
	$GPUParticles2D.emitting = true
	$PointLight2D.show()
	$PointLight2D.energy = 0
	var tween = create_tween()
	tween.tween_property($PointLight2D, "energy", 2.5, 0.1)
	
	await $GPUParticles2D.finished
	queue_free()
