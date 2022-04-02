extends Node2D

const DEBUG = true

onready var _camera = get_node("Camera2D")
onready var _cursor = get_node("Cursor")

var _buildings: Dictionary = {}
var _mouse_coord: Vector2 = Vector2.ZERO

var _house_scene = preload("res://building/House.tscn")
var _path_scene = preload("res://building/Path.tscn")


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta) -> void:
	_cursor.update_cursor(_mouse_coord, _buildings)
	
	
func _input(event) -> void:
	# Get the grid coordinate from mouse position
	_mouse_coord = (get_global_mouse_position() / GameData.CELL_SIZE).floor()
	
	if _cursor.is_valid_build():	
		# CHeck for mouse click to build. 
		if Input.is_action_just_pressed("build"):
			build(_mouse_coord, GameData.Buildings.HOUSE)
		elif Input.is_action_just_pressed("build_path"):
			build(_mouse_coord, GameData.Buildings.PATH)
		_cursor.update_cursor(_mouse_coord, _buildings, true)
	

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
	new_building.construct(coord, _buildings)
	add_child(new_building)
	_buildings[coord] = new_building


# Debug Draw
func _draw() -> void:
	draw_rect(Rect2(_mouse_coord * GameData.CELL_SIZE, Vector2.ONE * GameData.CELL_SIZE), Color(0, 0, 1, 1))
	
