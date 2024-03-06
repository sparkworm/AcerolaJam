extends Control

signal quit_pressed

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta):
	pass


func _on_quit_button_pressed():
	quit_pressed.emit()

func _on_close_menu_button_pressed():
	hide()
