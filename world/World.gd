extends Node2D

export(bool) var DEBUG_MODE = true

onready var _camera = get_node("Camera2D")
onready var _cursor = get_node("Cursor")
onready var _land_tiles = get_node("Land")

var _buildings: Dictionary = {}
var _buildable_cells: Dictionary = {}
var _mouse_coord: Vector2 = Vector2.ZERO

var _house_scene = preload("res://building/House.tscn")
var _path_scene = preload("res://building/Path.tscn")

var a_star = AStar.new()
var a_star_id: int = 0

var _noise = OpenSimplexNoise.new()
var _land_height = 11


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	_noise.seed = randi()
	_noise.octaves = 1
	_noise.period = 7
	
	for i in range(3, 13):
		_buildable_cells[Vector2(i, 6)] = null
		
	update_land(-3)


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta) -> void:
	_cursor.update_cursor(_mouse_coord, _buildable_cells)

	
func _input(event) -> void:
	# Get the grid coordinate from mouse position
	_mouse_coord = (get_global_mouse_position() / GameData.CELL_SIZE).floor()
	
	if _cursor.is_valid_build():	
		# CHeck for mouse click to build. 
		if Input.is_action_just_pressed("build"):
			build(_mouse_coord, GameData.Buildings.HOUSE)
		elif Input.is_action_just_pressed("build_path"):
			build(_mouse_coord, GameData.Buildings.PATH)
		_cursor.update_cursor(_mouse_coord, _buildable_cells, true)
	

func build(coord: Vector2, building: int) -> void:
	var new_building = null
	# Check what we're building
	match building:
		GameData.Buildings.PATH:
			new_building = _path_scene.instance()
		GameData.Buildings.HOUSE:
			new_building = _house_scene.instance()

	# Add new building
	new_building.connect("camera_shake_request", _camera, "_camera_shake_requested")
	new_building.a_star_id = a_star_id
	a_star_id += 1
	new_building.construct(coord, _buildings, _buildable_cells, a_star)
	
	add_child(new_building)
	_buildings[coord] = new_building
	GameData.update_max_height(coord)
	update_land(GameData.current_max_height.y)
	
	if DEBUG_MODE:
		update()


func update_land(max_height: int) -> void:
	while _land_height > max_height*2 - 4:
		var val = floor((4 * _noise.get_noise_2d(_land_height, 0)) + 4)
		# Left hand side 
		_land_tiles.set_cell(-1, _land_height, 0)
		_land_tiles.set_cell(0, _land_height, 0)
		for i in range(val):
			_land_tiles.set_cell(i, _land_height, 0)
		
		#RIght hand side
		val = floor((4 * _noise.get_noise_2d(_land_height, 20)) + 4)
		print(val)
		_land_tiles.set_cell(32, _land_height, 0)
		_land_tiles.set_cell(31, _land_height, 0)
		for i in range(33 - val, 32):
			_land_tiles.set_cell(i, _land_height, 0)
		_land_tiles.update_bitmask_region(Vector2(-1, _land_height), Vector2(32, _land_height))
		
		_land_height -= 1


# Debug Draw 
func _draw() -> void:
	for i in range(a_star_id - 1):
		var connections = a_star.get_point_connections(i)
		var p1 = a_star.get_point_position(i) * GameData.CELL_SIZE + Vector3(8, 8, 0)
		for j in connections:
			var p2 = a_star.get_point_position(j) * GameData.CELL_SIZE + Vector3(8, 8, 0)
			draw_line(Vector2(p1.x, p1.y), Vector2(p2.x, p2.y), Color(1, 1, 1, 1))
	
	
