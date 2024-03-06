class_name Level
extends GameScene

@export var level_name := "Blank Level"

@export var main_character: Node2D

## zoom cannot be more than max_zoom_amnt and cannot be less than 1/max_zoom_amnt
@export var max_zoom_amnt: float

@export_category("Technical")
@export var white_shader: ShaderMaterial

var to_center_on_main_character: Array[Node2D]

func _ready():
	initialize_view_map()
	initialize_light_map()
	initialize_background_rectangle()
	
	%ViewSprite.show()
	
	to_center_on_main_character.append_array([%BackgroundCamera, %LightMapCamera, %ViewMapCamera,
			%VisibilityPointLight, $ViewSprite, %BackgroundRectangle])
	
	%TileMap.modulate = Color(0.1,0.1,0.1,1)

func _process(_delta):
	center_on_main_character()
	if Input.is_action_just_pressed("zoom_in"):
		print("zooming in")
		zoom_cameras(4.0/3)
	if Input.is_action_just_pressed("zoom_out"):
		zoom_cameras(3.0/4)

func initialize_view_map() -> void:
	%ViewMap.size = Vector2(960, 540) # get_viewport().size
	%ViewMap.add_child(%TileMap.duplicate())
	%ViewMap.get_node("TileMap").material = white_shader
	print(%ViewMap.get_node("TileMap").material)

func initialize_light_map() -> void:
	%LightMap.size = Vector2(960, 540)
	%LightMap.add_child($MapItems.duplicate())
	$MapItems.queue_free()
	%LightMap.add_child(%TileMap.duplicate())

func initialize_background_rectangle() -> void:
	%BackgroundRectangle.texture.height = Vector2(960, 540).y
	%BackgroundRectangle.texture.width = Vector2(960, 540).x
	print(%BackgroundRectangle.texture.height)

func update_cameras() -> void:
	%BackgroundCamera.position = main_character.position
	%LightMapCamera.position = main_character.position
	%ViewMapCamera.position = main_character.position
	$ViewSprite.position = main_character.position
	

func center_on_main_character() -> void:
	for thing in to_center_on_main_character:
		thing.position = main_character.position

## zooms in all cameras by a certain amount
func zoom_cameras(amnt: float) -> void:
	var zoom_amnt := Vector2(amnt, amnt)
	for c in to_center_on_main_character:
		if c is Camera2D:
			print("camera found")
			c.zoom *= zoom_amnt
