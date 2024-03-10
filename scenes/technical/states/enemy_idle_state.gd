class_name EnemyIdleState
extends State

@export var detection: EnemyDetection

func _ready():
	state_name = "EnemyIdleState"

func update(_delta) -> void:
	pass

func enter(_args := {}) -> void:
	detection.enemy_entered_stealth_area.connect(Callable(self, "aggro"))
	detection.enemy_spotted.connect(Callable(self, "aggro"))

func exit() -> void:
	detection.enemy_entered_stealth_area.disconnect(Callable(self, "aggro"))
	detection.enemy_spotted.disconnect(Callable(self, "aggro"))

func aggro(body: Character):
	state_machine.change_state_to("ChasingState", {"target":body})
