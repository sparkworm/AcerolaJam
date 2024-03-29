class_name ChasingState
extends State

@export var detection: EnemyDetection
@export var nav_agent: NavigationAgent2D
@export var nav_refresh_time: float = 0.15

## this is the target that the enemy is current focused on, 
## almost always going to be the player
var target: Character

func _ready():
	state_name = "ChasingState"
	$NavTimer.wait_time = nav_refresh_time
	detection.enemy_exited_agression_area.connect(Callable(self, "deaggro"))

func update(delta) -> void:
	nav_update(delta)
	if detection.can_engage(target):
		state_machine.change_state_to("AttackState", {"target" : target})

func enter(args := {}) -> void:
	target = args["target"]
	$NavTimer.start()

func exit() -> void:
	$NavTimer.stop()
	character.execute_movement(Vector2.ZERO)

func nav_update(_delta) -> void:
	if nav_agent.is_navigation_finished():
		#print("navigation finished")
		return
	
	# the position for this might not work
	var direction = character.to_local(nav_agent.get_next_path_position()).normalized()
	#print(character.rotation*180.0/PI, ", ", direction.angle()*180.0/PI) 
	#character.execute_rotation(direction.angle(), delta)
	character.look_at(target.global_position)
	character.execute_movement(Vector2.from_angle(direction.angle()+character.rotation))

func nav_calculate() -> void:
	nav_agent.target_position = target.global_position


func _on_nav_timer_timeout():
	#print("nav timer timeout")
	nav_calculate()

func deaggro(body: Character) -> void:
	if body == target:
		state_machine.change_state_to("EnemyIdleState")
