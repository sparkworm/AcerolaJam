class_name ChasingState
extends State

@export var nav_agent: NavigationAgent2D
@export var nav_refresh_time: float = 0.15

## this is the target that the enemy is current focused on, 
## almost always going to be the player
var target: Character

func _ready():
	$NavTimer.wait_time = nav_refresh_time

func update(delta) -> void:
	nav_update(delta)

func enter(args := {}) -> void:
	target = args["target"]
	$NavTimer.start()

func exit() -> void:
	pass

func nav_update(delta) -> void:
	if nav_agent.is_navigation_finished():
		#print("navigation finished")
		return
	
	# the position for this might not work
	var direction = character.to_local(nav_agent.get_next_path_position()).normalized() 
	#character.execute_rotation(direction.angle(), delta)
	character.execute_movement(direction)

func nav_calculate() -> void:
	nav_agent.target_position = target.global_position


func _on_nav_timer_timeout():
	#print("nav timer timeout")
	nav_calculate()
