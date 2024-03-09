class_name EnemyIdleState
extends State

@export var detection: EnemyDetection

func _ready():
	detection.enemy_entered_stealth_area.connect(Callable(self, "aggro"))
	detection.enemy_spotted.connect(Callable(self, "aggro"))

func update(_delta) -> void:
	pass

func enter(_args := {}) -> void:
	pass

func exit() -> void:
	pass

func aggro(body: Character):
	state_machine.change_state_to("ChasingState", {"target":body})
