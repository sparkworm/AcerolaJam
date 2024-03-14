## a weapon, which can be held by a character
class_name Weapon
extends Equipment

@export var projectile: PackedScene
## the amount of ammo the weapon has.
## [br] -1 indicates infinite ammo
@export var max_ammo: int = -1
@export var fire_effect: PackedScene
## a small float value representing the radians coverd by the spread
@export var inaccuracy: float = 0.3
## whether or not the weapon is melee
## [br] melee weapons still spawn a projectile, but their projectile despawns 
## before traveling very far
@export var is_melee: bool = false
## the amount of time in seconds that it takes for an enemy to reload
@export var reload_time: float
## the amount the screen shakes when the weapon is fired
@export var recoil_amnt: float

var ammo_amnt: int

signal fired(proj: Projectile, recoil: float)

func _ready():
	super._ready()
	ammo_amnt = max_ammo

func execute_use() -> void:
	if sufficient_ammo():
		remove_ammo()
		spawn_projectile()
		if fire_effect != null:
			spawn_fire_effect()
	else:
		print("playing empty fire sound")
		%EmptyFireSound.play()

func spawn_projectile() -> void:
	var proj = projectile.instantiate()
	proj.global_position = %SpawnPoint.global_position
	var variance = randf_range(-inaccuracy/2.0, inaccuracy/2.0)
	proj.rotation = global_rotation + variance
	fired.emit(proj, recoil_amnt)
	%FireSound.play()

func spawn_fire_effect() -> void:
	var effect = fire_effect.instantiate()
	effect.position = %SpawnPoint.position
	add_child(effect)
	effect.activate()

func remove_ammo() -> void:
	if ammo_amnt > 0:
		ammo_amnt -= 1

func sufficient_ammo() -> bool:
	return ammo_amnt > 0 or ammo_amnt == -1

func refill_ammo(amnt:int=max_ammo) -> void:
	ammo_amnt = min(ammo_amnt+amnt, max_ammo)
	%ReloadSound.play()
