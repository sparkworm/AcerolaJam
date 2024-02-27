extends Node

func _ready():
	$MainMenu.quit_pressed.connect(Callable(self, "quit_game"))

func _process(_delta):
	if Input.is_action_just_pressed("esc"):
		main_menu_toggle()

func main_menu_toggle():
	if $MainMenu.visible == false:
		$MainMenu.show()
	else:
		$MainMenu.hide()

func quit_game():
	get_tree().quit()
