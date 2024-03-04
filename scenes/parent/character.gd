class_name Character
extends CharacterBody2D

## controlls the actions of the character
@export var controller: Controller

@export_category("Combat")
## the amount of health points that a character has
## [br] upon reaching zero, the character dies
@export var health: int = 100

@export_category("Movement")
## pixels per second that the character can move forward [br]
## speed is calculated as 1/3 + (2/3)cos(angle of movement from rotation)
@export var speed: int = 300
## amount of rotations per second possible
@export var rotation_speed: float = 1

## emitted when the character dies
signal died()

func _ready():
	# connect controller signals to actual character actions
	controller.move.connect(Callable(self, "execute_movement"))
	controller.rotate.connect(Callable(self, "execute_rotation"))

func _physics_process(delta):
	move_and_slide()

func execute_movement(direction: Vector2) -> void:
	#velocity = direction * speed
	velocity = direction*speed*((1.0/2) + max((1.0/2)*cos(rotation - direction.angle()), 0))

func execute_rotation(target_direction: float, delta: float) -> void:
	rotation = rotate_toward(rotation, target_direction, 2*PI*rotation_speed*delta)

## this function is called when the character is hit
func hit(damage: int):
	health -= damage
	if health <= 0:
		die()

## this function is called when the character drops to 0 health
func die():
	# should probably call a die animation, a die sound, and possibly a die drop
	died.emit()
	queue_free()