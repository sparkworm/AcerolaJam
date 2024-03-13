class_name Character
extends CharacterBody2D

enum ALIGNMENTS {
	enemy,
	player,
	neutral,
}

## controls the actions of the character
@export var controller: Controller

@export_category("Combat")
@export var alignment: ALIGNMENTS 
## the amount of health points that a character has
## [br] upon reaching zero, the character dies :(
@export var health: int = 100
@export var item_type_held: Equipment.ITEM_CATAGORIES
@export var extra_inaccuracy: float = 0.0

@export_category("Movement")
## pixels per second that the character can move forward [br]
## speed is calculated as 1/3 + (2/3)cos(angle of movement from rotation)
@export var speed: int = 20
## amount of rotations per second possible
@export var rotation_speed: float = 1

@export_category("Technical")
@export var weapon_drop: PackedScene

var actions: Array[Equipment]

## emitted when the character dies
signal died(coords: Vector2)
signal is_hit(coords: Vector2, damage: int)
signal weapon_dropped(weapon: WeaponDrop)
signal weapon_fired(projectile: Projectile, recoil: float, character: Character)

func _ready():
	# connect controller signals to actual character actions
	controller.move.connect(Callable(self, "execute_movement"))
	controller.rotate.connect(Callable(self, "execute_rotation"))
	controller.use_item.connect(Callable(self, "use_item"))
	controller.change_item.connect(Callable(self, "change_equipment"))
	controller.grab_item.connect(Callable(self, "pick_up_equipment"))
	controller.drop_item.connect(Callable(self, "drop_held_item"))
	
	%Inventory.weapon_dropped.connect(Callable(self, "create_weapon_drop"))
	
	%Inventory.change_item_held(item_type_held)
	
	for equipment in get_equipment():
			if equipment is Weapon:
				equipment.fired.connect(Callable(self, "emit_fired_projectile"))
	
	'
	for child in $Equipment.get_children():
		child = child as Equipment
		actions.append(child)
	'

func _physics_process(_delta):
	move_and_slide()

## makes the character move in the specified direction
func execute_movement(direction: Vector2) -> void:
	#velocity = direction * speed
	velocity = direction * speed * \
			((1.0/2) + max((1.0/2)*cos(rotation - direction.angle()), 0))

func execute_rotation(target_direction: float, delta: float) -> void:
	rotation = rotate_toward(rotation, target_direction, 2*PI*rotation_speed*delta)

func emit_fired_projectile(projectile: Projectile, recoil: float) -> void:
	weapon_fired.emit(projectile, recoil, self)

## this function is called when the character is hit
func hit(damage: int):
	health -= damage
	%HitSound.play()
	is_hit.emit(position, damage)
	if health <= 0:
		die()

## this function is called when the character drops to 0 health
func die():
	# makes character drop what they're holding
	if get_item_held() != null:
		drop_held_item()
	# play death sound
	%DieSound.play()
	# emit death signal
	died.emit(position)
	# hide visible things as the sound finishes
	$CollisionShape2D.set_deferred("disabled", true)
	$Sprite2D.hide()
	$Flashlight.hide()
	%DieSound.finished.connect(Callable(self, "queue_free"))

#region equipment

func can_use_item() -> bool:
	return %Inventory.can_use_held_item()

## calls use() on the held piece of Equipment
# !! can be skipped by connnecting the signal straight to the inventory's
# use_item()
func use_item() -> void:
	if can_use_item():
		get_item_held().rotation = randf_range(-extra_inaccuracy, extra_inaccuracy)
		%Inventory.use_item()
	

## returns an array of all the equipment held by the character
func get_equipment() -> Array[Equipment]:
	return %Inventory.get_all_items()

func get_item_held() -> Equipment:
	return %Inventory.item_held

func change_equipment(idx: Equipment.ITEM_CATAGORIES) -> void:
	%Inventory.change_item_held(idx)

func drop_held_item() -> void:
	drop_item(get_item_held())

func drop_item(item: Equipment) -> void:
	$Inventory.remove_item(item.item_catagory)

func create_weapon_drop(item: Equipment) -> void:
	var drop = weapon_drop.instantiate() as WeaponDrop
	drop.velocity = Vector2.from_angle(rotation)*randf_range(30, 60)
	drop.add_weapon(item)
	drop.global_position = global_position + Vector2.from_angle(rotation)*10
	weapon_dropped.emit(drop)

func pick_up_equipment() -> void:
	for body in %PickupArea.get_overlapping_bodies():
		if body is WeaponDrop:
			for c in body.get_weapon().fired.get_connections():
				body.get_weapon().fired.disconnect(c["callable"])
			body.get_weapon().fired.connect(Callable(self, "emit_fired_projectile"))
			%Inventory.add_item(body.get_weapon())
			body.queue_free()
			return

'
## calls use() on an action if it is within the bounds of actions[]
func execute_action(action_index: int) -> void:
	if action_index < actions.size():
		actions[action_index].use()

## returns an array of all the equipment held by the character
func get_equipment() -> Array[Equipment]:
	var equip_array: Array[Equipment] = []
	for e in %Equipment.get_children():
		equip_array.append(e)
	return equip_array
'

#endregion
