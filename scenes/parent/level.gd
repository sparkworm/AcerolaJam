class_name Level
extends GameScene

@export var level_name := "Blank Level"

@export var main_character: Node2D

@export_category("Visual")
@export_color_no_alpha var background_map_tint: Color = Color(0.1, 0.1, 0.1)

@export_category("Camera")
## zoom cannot be more than max_zoom_amnt
@export var max_zoom_amnt: float = 2
@export var min_zoom_amnt: float = 1
@export var zoom_increment: float = 0.1

@export_category("Technical")
@export var white_shader: ShaderMaterial
@export var blood_decal_spawner: PackedScene
@export var blood_decal: PackedScene

var map_items: Node2D
var to_center_on_main_character: Array[Node2D]

func _ready():
	map_items = %MapItems
	
	for character:Character in %MapItems/Characters.get_children():
		for equipment in character.get_equipment():
			if equipment is Weapon:
				equipment.fired.connect(Callable(self, "spawn_projectile"))
		var hit_callable = Callable(self, "spawn_blood_splatter")
		#hit_callable = hit_callable.bind(12)
		character.is_hit.connect(hit_callable)
		
	
	initialize_view_map()
	initialize_light_map()
	#initialize_background_rectangle()
	initialize_background_map()
	
	%TileMap.queue_free()
	
	%ViewSprite.show()
	%BackgroundSprite.show()
	
	to_center_on_main_character.append_array(
			[%BackgroundCamera, %LightMapCamera, %ViewMapCamera, %OuterCamera,
			%VisibilityPointLight, $ViewSprite, %BackgroundRectangle, 
			%BackgroundSprite])
	
	

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

func initialize_light_map() -> void:
	%LightMap.size = get_tree().root.content_scale_size
	%MapItems/Props.reparent(%NavigationRegion2D)
	%MapItems.reparent(%LightMap)
	#%LightMap.add_child($MapItems.duplicate())
	#$MapItems.queue_free()
	%LightMap/NavigationRegion2D.add_child(%TileMap.duplicate())
	$LightMap/NavigationRegion2D.bake_navigation_polygon()
	
	
	# initialize background rectangle
	%BackgroundRectangle.texture.height = get_tree().root.content_scale_size.y
	%BackgroundRectangle.texture.width = get_tree().root.content_scale_size.x

func initialize_background_map() -> void:
	%BackgroundMap.size = get_tree().root.content_scale_size
	%TileMap.modulate = background_map_tint
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
	shake_cameras(5)

func spawn_blood_splatter(coords: Vector2, amnt: int) -> void:
	for i in range(amnt):
		var blood_spawner = blood_decal_spawner.instantiate() as BloodDecalSpawner
		var direction: Vector2 = Vector2.from_angle(randf_range(0, 2*PI))
		var magnitude: float = randf_range(40,300)
		
		blood_spawner.spawn_blood_decal.connect(Callable(self, "spawn_blood_decal"))
		%LightMap/MapItems/Decals.call_deferred("add_child", (blood_spawner))
		blood_spawner.position = coords
		#blood_spawner._integrate_forces(PhysicsDirectBodyState2D.linear_velocity = Vector2(100,10))
		#blood_spawner.apply_central_impulse(direction*magnitude*100)
		blood_spawner.velocity = direction*magnitude
		blood_spawner.initial_v = blood_spawner.velocity.length()
		

func spawn_blood_decal(coords: Vector2, initial_velocity) -> void:
	var blood = blood_decal.instantiate() as BloodDecal
	blood.position = coords
	blood.max_size = 25/(initial_velocity)
	%LightMap/MapItems/Decals.add_child(blood)
#endregion

func shake_cameras(magnitude: float) -> void:
	#var shake_vector := Vector2(randf_range(-1,1)*magnitude, 
			#randf_range(-1,1)*magnitude)
	
	#var shake_vector := Vector2(magnitude, magnitude)
	
	var shake_vector := Vector2.from_angle(randf_range(0, 2*PI))*magnitude
	
	
	for camera in get_cameras():
		if camera != %OuterCamera:
			var offset_tween = create_tween()
			offset_tween.tween_property(camera, "offset", shake_vector, 0.05)
			offset_tween.tween_property(camera, "offset", Vector2.ZERO, 0.05)
			camera.offset += shake_vector

func update_cameras() -> void:
	%BackgroundCamera.position = main_character.position
	%LightMapCamera.position = main_character.position
	%ViewMapCamera.position = main_character.position
	$ViewSprite.position = main_character.position

func get_cameras() -> Array[Camera2D]:
	var cam_array: Array[Camera2D] = []
	for child in to_center_on_main_character:
		if child is Camera2D:
			cam_array.append(child)
	return cam_array

func center_on_main_character() -> void:
	for thing in to_center_on_main_character:
		thing.position = main_character.position

## zooms in all cameras by a certain amount
func zoom_cameras(amnt: float) -> void:
	var zoom_amnt := Vector2(amnt, amnt)
	for c in get_cameras():
		if c != %OuterCamera:
			if (c.zoom.x + amnt > max_zoom_amnt 
					or c.zoom.x + amnt < min_zoom_amnt):
				return
			
			c.zoom += zoom_amnt
