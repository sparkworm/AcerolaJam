class_name Character
extends CharacterBody2D

enum ALIGNMENTS {
	enemy,
	player,
	neutral,
}

## controlls the actions of the character
@export var controller: Controller

@export_category("Combat")
@export var alignment: ALIGNMENTS 
## the amount of health points that a character has
## [br] upon reaching zero, the character dies :(
@export var health: int = 100

@export_category("Movement")
## pixels per second that the character can move forward [br]
## speed is calculated as 1/3 + (2/3)cos(angle of movement from rotation)
@export var speed: int = 100
## amount of rotations per second possible
@export var rotation_speed: float = 1

var actions: Array[Equipment]

## emitted when the character dies
signal died()

func _ready():
	# connect controller signals to actual character actions
	controller.move.connect(Callable(self, "execute_movement"))
	controller.rotate.connect(Callable(self, "execute_rotation"))
	controller.action.connect(Callable(self, "execute_action"))
	
	for child in $Equipment.get_children():
		child = child as Equipment
		actions.append(child)

func _physics_process(_delta):
	move_and_slide()

## makes the character move in the specified direction
func execute_movement(direction: Vector2) -> void:
	#velocity = direction * speed
	velocity = direction * speed * \
			((1.0/2) + max((1.0/2)*cos(rotation - direction.angle()), 0))

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

## calls use() on an action if it is within the bounds of actions[]
func execute_action(action_index: int) -> void:
	if action_index < actions.size():
		actions[action_index].use()

## returns an array of all the equipment held by the character
func get_equipment() -> Array[Equipment]:
	var equip_array: Array[Equipment] = []
	for e in %Equipment.get_children():
		equip_array.append(e)
	return equip_array
