class_name EnemyIdleState
extends State

@export var detection: EnemyDetection

@export var rotation_range: float

var starting_rotation: float
var early_rotation: float
var late_rotation: float
var rotation_tween: Tween

func _ready():
	#starting_rotation = character.rotation
	state_name = "EnemyIdleState"
	
	

func rotate() -> void:
	rotation_tween = create_tween()
	#while starting_rotation < 0:
		#print(starting_rotation)
		#starting_rotation += 2*PI
	#while starting_rotation > 2*PI:
		#starting_rotation -= 2*PI
	print(character, " rotating from to ", character.rotation, ", ", early_rotation)
	rotation_tween.tween_property(character, "rotation", early_rotation, \
			(rotation_range/3)/character.rotation_speed)
	#character.rotation = starting_rotation-rotation_range/2
	#print(character, " first tween rotation: ", character.rotation)
	print(character, " rotating from to ", character.rotation, ", ", starting_rotation)
	rotation_tween.tween_property(character, "rotation", starting_rotation, \
			(rotation_range/3)/character.rotation_speed)
	#print(character, " second tween rotation: ", character.rotation)
	print(character, " rotating from to ", character.rotation, ", ", late_rotation)
	rotation_tween.tween_property(character, "rotation", late_rotation, \
			(rotation_range/3)/character.rotation_speed)
	#print(character, " third tween rotation: ", character.rotation)
	#character.rotation = starting_rotation+rotation_range/2
	
	rotation_tween.finished.connect(Callable(self, "rotate"))

func update(_delta) -> void:
	pass

func enter(_args := {}) -> void:
	starting_rotation = character.rotation# - 6*PI
	early_rotation = starting_rotation - rotation_range/2
	late_rotation = starting_rotation + rotation_range/2
	print(character, " Starting rotation: ", starting_rotation)
	#while starting_rotation < 0:
		#print(starting_rotation)
		#starting_rotation += 2*PI
	#while starting_rotation > 2*PI:
		#starting_rotation -= 2*PI
	print(starting_rotation)
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
