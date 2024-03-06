class_name Level
extends GameScene

@export var level_name := "Blank Level"

@export var main_character: Node2D

@export_category("Camera")
## zoom cannot be more than max_zoom_amnt
@export var max_zoom_amnt: float = 2
@export var min_zoom_amnt: float = 0.75
@export var zoom_increment: float = 0.2

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
		zoom_cameras(zoom_increment)
	if Input.is_action_just_pressed("zoom_out"):
		zoom_cameras(-zoom_increment)

#region initialization

func initialize_view_map() -> void:
	%ViewMap.size = get_tree().root.content_scale_size # get_viewport().size
	%ViewMap.add_child(%TileMap.duplicate())
	%ViewMap.get_node("TileMap").material = white_shader
	print(%ViewMap.get_node("TileMap").material)

func initialize_light_map() -> void:
	%LightMap.size = get_tree().root.content_scale_size
	%LightMap.add_child($MapItems.duplicate())
	$MapItems.queue_free()
	%LightMap.add_child(%TileMap.duplicate())

func initialize_background_rectangle() -> void:
	%BackgroundRectangle.texture.height = get_tree().root.content_scale_size.y
	%BackgroundRectangle.texture.width = get_tree().root.content_scale_size.x
	print(%BackgroundRectangle.texture.height)
#endregion

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
			if (c.zoom.x + amnt >= max_zoom_amnt 
					or c.zoom.x + amnt <= min_zoom_amnt):
				return
			
			c.zoom += zoom_amnt
