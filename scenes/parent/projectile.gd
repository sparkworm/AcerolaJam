class_name Projectile
extends Area2D

## speed in pixels per second
@export var speed: int
@export var damage: int

var last_position: Vector2
var velocity: Vector2

func _ready():
	area_entered.connect(Callable(self, "hit_target"))
	last_position = position
	velocity = speed*Vector2(cos(rotation), sin(rotation))

func _physics_process(delta):
	move(delta)

func move(delta) -> void:
	position += velocity * delta
	%RayCast2D.target_position = last_position - global_position
	last_position = global_position
	
	if %RayCast2D.is_colliding():
		position = %RayCast2D.get_collision_point()
	
	#if %RayCast2D.is_colliding():
		#hit_target(%RayCast2D.get_collider())

func hit_target(target: Node2D) -> void:
	if target.has_method("hit"):
		target.hit(damage)
	die()

## called after the particle hits something
func die() -> void:
	queue_free()
