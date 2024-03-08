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

var map_items: Node2D
var to_center_on_main_character: Array[Node2D]

func _ready():
	map_items = %MapItems
	
	for character in %MapItems/Characters.get_children():
		for equipment in character.get_equipment():
			if equipment is Weapon:
				equipment.fired.connect(Callable(self, "spawn_projectile"))
	
	initialize_view_map()
	initialize_light_map()
	#initialize_background_rectangle()
	initialize_background_map()
	
	%TileMap.queue_free()
	
	%ViewSprite.show()
	%BackgroundSprite.show()
	
	to_center_on_main_character.append_array(
			[%BackgroundCamera, %LightMapCamera, %ViewMapCamera, %OuterCamera,
			%VisibilityPointLight, $ViewSprite, %BackgroundRectangle, %BackgroundSprite])
	
	

func _process(_delta):
	center_on_main_character()
	if Input.is_action_just_pressed("zoom_in"):
		zoom_cameras(zoom_increment)
	if Input.is_action_just_pressed("zoom_out"):
		zoom_cameras(-zoom_increment)
	
	#print("\nget_tree().root.content_scale_size ", get_tree().root.content_scale_size)

#region initialization

func initialize_view_map() -> void:
	%ViewMap.size = get_tree().root.content_scale_size # get_viewport().size
	%ViewMap.add_child(%TileMap.duplicate())
	%ViewMap.get_node("TileMap").material = white_shader

func initialize_light_map() -> void:
	%LightMap.size = get_tree().root.content_scale_size
	%MapItems.reparent(%LightMap)
	#%LightMap.add_child($MapItems.duplicate())
	#$MapItems.queue_free()
	%LightMap.add_child(%TileMap.duplicate())
	
	# initialize background rectangle
	%BackgroundRectangle.texture.height = get_tree().root.content_scale_size.y
	%BackgroundRectangle.texture.width = get_tree().root.content_scale_size.x

func initialize_background_map() -> void:
	%BackgroundMap.size = get_tree().root.content_scale_size
	%TileMap.modulate = Color(0.1,0.1,0.1,1)
	%BackgroundMap.add_child(%TileMap.duplicate())

#func initialize_background_rectangle() -> void:

#endregion

#region children management
func spawn_character(character: Character) -> void:
	for equipment in character.get_equipment():
			if equipment is Weapon:
				equipment.fired.connect(Callable(self, "spawn_projectile"))
	map_items.get_node("Characters").add_child(character)

func spawn_projectile(proj: Projectile) -> void:
	map_items.get_node("Projectiles").add_child(proj)
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
