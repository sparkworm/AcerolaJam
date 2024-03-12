class_name PlayerController
extends Controller

@export_category("Keybinds")
@export var key_up: String = "key_up"
@export var key_down: String = "key_down"
@export var key_left: String = "key_left"
@export var key_right: String = "key_right"
@export var key_action1: String = "action1"
#@export var key_action2: String = "action2"
@export var key_item_melee: String = "item_melee"
@export var key_item_ranged: String = "item_ranged"
@export var key_interact: String = "interact"
@export var key_reload: String = "reload"

func _process(delta):
	calculate_movement(delta)
	calculate_rotation(delta)
	if Input.is_action_pressed(key_action1):
		use_item.emit()
	if Input.is_action_just_pressed(key_item_melee):
		change_item.emit(Equipment.ITEM_CATAGORIES.melee_weapon)
	if Input.is_action_just_pressed(key_item_ranged):
		change_item.emit(Equipment.ITEM_CATAGORIES.ranged_weapon)
	if Input.is_action_just_pressed(key_reload):
		if character.get_item_held() == null:
			grab_item.emit()
		else:
			drop_item.emit()

## calculates the movement that should be performed, and emits the move signal to accomodate
func calculate_movement(_delta) -> void:
	var move_axis := Vector2(Input.get_axis(key_left, key_right),
			Input.get_axis(key_up, key_down)).normalized()
	move.emit(move_axis)

## calculates the rotation that should be performed, and emits the rotate signal to accomodate
func calculate_rotation(delta) -> void:
	var direction_vector: Vector2 = \
			(character.get_viewport().get_parent().get_global_mouse_position() - 
			character.global_position)
	var r = direction_vector.angle()
	rotate.emit(r, delta)
