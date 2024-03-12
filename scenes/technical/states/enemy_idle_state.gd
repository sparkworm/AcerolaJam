class_name EnemyIdleState
extends State

@export var detection: EnemyDetection

@export var rotation_range: float

var starting_rotation: float
var rotation_tween: Tween

func _ready():
	#starting_rotation = character.rotation
	state_name = "EnemyIdleState"

func rotate() -> void:
	rotation_tween = create_tween()
	rotation_tween.tween_property(character, "rotation", starting_rotation-rotation_range/2, \
			(rotation_range/2)/character.rotation_speed)
	rotation_tween.tween_property(character, "rotation", starting_rotation+rotation_range/2, \
			(rotation_range/2)/character.rotation_speed)
	rotation_tween.finished.connect(Callable(self, "rotate"))

func update(_delta) -> void:
	pass

func enter(_args := {}) -> void:
	starting_rotation = character.rotation
	detection.enemy_entered_stealth_area.connect(Callable(self, "aggro"))
	detection.enemy_spotted.connect(Callable(self, "aggro"))
	var noticed_enemy = detection.noticed_enemy()
	if noticed_enemy != null:
		aggro(noticed_enemy)
		print(noticed_enemy)
	else:
		print("noticed enemy is null")
	rotate()

func exit() -> void:
	detection.enemy_entered_stealth_area.disconnect(Callable(self, "aggro"))
	detection.enemy_spotted.disconnect(Callable(self, "aggro"))
	rotation_tween.kill()
	

func aggro(body: Character):
	state_machine.change_state_to("ChasingState", {"target":body})
