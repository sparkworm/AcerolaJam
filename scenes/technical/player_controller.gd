class_name PlayerController
extends Controller

@export_category("Keybinds")
@export var key_up: String
@export var key_down: String
@export var key_left: String
@export var key_right: String
@export var key_action1: String
@export var key_action2: String
@export var key_interact: String
@export var key_reload: String

func _process(delta):
	calculate_movement()
	calculate_rotation(delta)

## calculates the movement that should be performed, and emits the move signal to accomodate
func calculate_movement() -> void:
	var move_axis := Vector2(Input.get_axis(key_left, key_right),
			Input.get_axis(key_up, key_down))
	move.emit(move_axis)

## calculates the rotation that should be performed, and emits the rotate signal to accomodate
func calculate_rotation(delta) -> void:
	var direction_vector := (character.get_global_mouse_position() - character.global_position)
	var r = direction_vector.angle()
	rotate.emit(r, delta)
