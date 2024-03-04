extends Node

@export var main_menu: Control
@export var starting_scene: PackedScene

func _ready():
	main_menu.quit_pressed.connect(Callable(self, "quit_game"))
	change_scene(starting_scene)

func _process(_delta):
	if Input.is_action_just_pressed("esc"):
		main_menu_toggle()

## changes the active scene to the specified next_scene
func change_scene(next_scene: PackedScene):
	for child in $ActiveScene.get_children():
		$ActiveScene.remove_child(child)
	var ns = next_scene.instantiate() as GameScene
	ns.scene_changed.connect(Callable(self, "change_scene"))
	$ActiveScene.add_child(ns)
	

func main_menu_toggle():
	if main_menu.visible == false:
		main_menu.show()
	else:
		main_menu.hide()

func quit_game():
	get_tree().quit()
