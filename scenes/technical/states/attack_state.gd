class_name AttackState
extends State

@export var detection: EnemyDetection

var target: Character

func _ready():
	state_name = "AttackState"

func update(_delta) -> void:
	character.look_at(target.position)
	if detection.can_engage(target):
		character.use_item() # going to be called a lot, could be improved by connecting the signal
	else:
		state_machine.change_state_to("ChasingState", {"target" : target})
	if not character.get_item_held().sufficient_ammo():
		state_machine.change_state_to("ReloadState", {"target" : target})
	

func enter(args := {}) -> void:
	target = args["target"]

func exit() -> void:
	pass
