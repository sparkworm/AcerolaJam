extends State

var reload_time: float
var target: Character

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.
'
func update(_delta) -> void:
	character.look_at(target.global_position)
'
func enter(args:={}) -> void:
	target = args["target"]
	var item := character.get_item_held()
	if item is Weapon:
		reload_time = item.reload_time
		var ammo_tween = create_tween()
		#ammo_tween.tween_property(item, "ammo_amnt", item.max_ammo, item.reload_time)
		ammo_tween.tween_property(item, "rotation", -PI, item.reload_time/2)
		ammo_tween.set_parallel(false)
		ammo_tween.tween_property(item, "rotation", 0, item.reload_time/2)
		item.refill_ammo()
		var switch_to_attack = Callable(state_machine, "change_state_to")
		switch_to_attack = switch_to_attack.bindv(["AttackState", {"target":target}])
		ammo_tween.finished.connect(switch_to_attack)
		
	else:
		print("Character tried to reload a non-weapon, this is very bad")
	#state_machine.change_state_to("AttackState", {"target":target})
