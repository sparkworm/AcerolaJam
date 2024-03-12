class_name Character
extends CharacterBody2D

enum ALIGNMENTS {
	enemy,
	player,
	neutral,
}

## controls the actions of the character
@export var controller: Controller

@export_category("Combat")
@export var alignment: ALIGNMENTS 
## the amount of health points that a character has
## [br] upon reaching zero, the character dies :(
@export var health: int = 100
@export var item_type_held: Equipment.ITEM_CATAGORIES

@export_category("Movement")
## pixels per second that the character can move forward [br]
## speed is calculated as 1/3 + (2/3)cos(angle of movement from rotation)
@export var speed: int = 100
## amount of rotations per second possible
@export var rotation_speed: float = 1

var actions: Array[Equipment]

## emitted when the character dies
signal died(coords: Vector2)
signal is_hit(coords: Vector2, damage: int)

func _ready():
	# connect controller signals to actual character actions
	controller.move.connect(Callable(self, "execute_movement"))
	controller.rotate.connect(Callable(self, "execute_rotation"))
	controller.use_item.connect(Callable(self, "use_item"))
	controller.change_item.connect(Callable(self, "change_equipment"))
	
	%Inventory.change_item_held(item_type_held)
	'
	for child in $Equipment.get_children():
		child = child as Equipment
		actions.append(child)
	'

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
	is_hit.emit(position, damage)
	if health <= 0:
		die()

## this function is called when the character drops to 0 health
func die():
	# should probably call a die animation, a die sound, and possibly a die drop
	died.emit(position)
	queue_free()

#region equipment

func can_use_item() -> bool:
	return %Inventory.can_use_held_item()

## calls use() on the held piece of Equipment
# !! can be skipped by connnecting the signal straight to the inventory's
# use_item()
func use_item() -> void:
	%Inventory.use_item()

## returns an array of all the equipment held by the character
func get_equipment() -> Array[Equipment]:
	return %Inventory.get_all_items()

func change_equipment(idx: Equipment.ITEM_CATAGORIES) -> void:
	%Inventory.change_item_held(idx)

'
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
'

#endregion
