extends VisualEffect


func activate() -> void:
	$GPUParticles2D.emitting = true
	$PointLight2D.show()
	
	await $GPUParticles2D.finished
	queue_free()
