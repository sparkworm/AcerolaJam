class_name EnemyController
extends Controller
 
## this is the target that the enemy is current focused on, almost always going to be the player
var target: Character
var target_detected: bool

func _process(delta):
	calculate_movement(delta)
	calculate_rotation(delta)

func calculate_movement(delta) -> void:
	pass

func calculate_rotation(delta) -> void:
	pass

