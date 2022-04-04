extends Node2D

export(bool) var DEBUG_MODE = true

onready var _camera = get_node("Camera2D")
onready var _cursor = get_node("Cursor")
onready var _land_tiles = get_node("Land")
onready var _agents = get_node("Agents")

var _buildings: Dictionary = {}
var _buildable_cells: Dictionary = {}
var _mouse_coord: Vector2 = Vector2.ZERO

var _house_scene = preload("res://building/House.tscn")
var _path_scene = preload("res://building/Path.tscn")
var _agent_scene = preload("res://agent/Agent.tscn")
var _platform_scene = preload("res://world/Platform.tscn")

var a_star = AStar.new()
var a_star2 = AStar.new()
var a_star_id: int = 0

var _noise = OpenSimplexNoise.new()
var _land_height = 11

var _platforms = {}


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	GameData.connect("game_over", self, "on_game_over")
	
	randomize()
	_noise.seed = randi()
	_noise.octaves = 1
	_noise.period = 7
	
	for i in range(2, 14):
		build(Vector2(i, 6), GameData.Buildings.PATH, true)
		
	a_star.remove_point(0)
	a_star2.remove_point(0)
	a_star.remove_point(11)
	a_star2.remove_point(11)
		
	update_land(-3)
	
	randomize()
	
	for i in range(GameData.STARTING_POPULATION):
		add_agent(Vector2(floor(randf() * 10 + 3), 6))

	$Water.start_rise()
	
	GameData.num_paths = GameData.START_PATHS


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta) -> void:
	_cursor.update_cursor(_mouse_coord, _buildable_cells, true)
	
#	print(floor((_camera.position.y - 72) / GameData.CELL_SIZE))
	if GameData.update_max_height(floor((_camera.position.y - 72) / GameData.CELL_SIZE)):
		update_land(GameData.current_max_height)

	if Input.is_action_just_pressed("fullscreen"):
		OS.window_fullscreen = !OS.window_fullscreen
	
#	if DEBUG_MODE:
#		update()
	
func _input(event) -> void:
	# Get the grid coordinate from mouse position
	_mouse_coord = (get_global_mouse_position() / GameData.CELL_SIZE).floor()
	print(_mouse_coord)
	if _cursor.is_valid_build():	
		# CHeck for mouse click to build. 
		if Input.is_action_just_pressed("build"):
			build(_mouse_coord, GameData.Buildings.HOUSE)
		elif Input.is_action_just_pressed("build_path") and GameData.num_paths > 0:
			build(_mouse_coord, GameData.Buildings.PATH)
		_cursor.update_cursor(_mouse_coord, _buildable_cells, true)
	

func check_platforms(coords: Vector2):
	for p in _platforms.keys():
		if p == coords + Vector2.LEFT:
			for a in _platforms[p].agents:
				a.registered = true
				GameData.add_agent()
			_platforms[p].hide_mark()
			a_star.connect_points(_platforms[p].a_star_id, _buildings[coords].a_star_id)
			AudioManager.play("saved")
		elif p == coords + Vector2.RIGHT:
			for a in _platforms[p].agents:
				a.registered = true
				GameData.add_agent()
			_platforms[p].hide_mark()
			a_star.connect_points(_platforms[p].a_star_id, _buildings[coords].a_star_id)
			AudioManager.play("saved")
			print(a_star.get_point_position(_platforms[p].a_star_id))


func build(coord: Vector2, building: int, mute=false) -> void:
	var new_building = null
	# Check what we're building
	match building:
		GameData.Buildings.PATH:
			if !mute:
				AudioManager.play("main_build")
			new_building = _path_scene.instance()
			GameData.num_paths -= 1
		GameData.Buildings.HOUSE:
			AudioManager.play("built1")
			new_building = _house_scene.instance()

	# Add new building
	new_building.connect("camera_shake_request", _camera, "_camera_shake_requested")
	new_building.a_star_id = a_star_id
	new_building.a_star = a_star
	new_building.a_star2 = a_star2
	a_star_id += 1
	new_building.construct(coord, _buildings, _buildable_cells)
	
	add_child(new_building)
	_buildings[coord] = new_building
	
	#if building == GameData.Buildings.PATH:
	check_platforms(coord)
	
#	on_house_vacancy(coord, new_building.a_star_id)
#
#	GameData.update_max_height(coord.y)
	GameData.update_building_height(coord.y)
#	update_land(GameData.current_max_height)


func add_agent(coord: Vector2, add=true):
	var agent = _agent_scene.instance()
	agent._coords = coord
	agent.position = coord * GameData.CELL_SIZE + Vector2(floor(randf() * 4.0 - 2), 0)
	agent.buildings = _buildings
	agent.a_star = a_star
	agent.a_star2 = a_star2
	_agents.add_child(agent)
	if add:
		agent.registered = true
		GameData.add_agent()
	return agent


func update_land(max_height: int) -> void:
	while _land_height > max_height*2 - 4:
		var val = min(4, floor((4 * _noise.get_noise_2d(_land_height, 0)) + 4))
		# Left hand side 
		_land_tiles.set_cell(-1, _land_height, 0)
		_land_tiles.set_cell(0, _land_height, 0)
		for i in range(val):
			_land_tiles.set_cell(i, _land_height, 0)
		
		#RIght hand side
		val = min(4, floor((4 * _noise.get_noise_2d(_land_height, 20)) + 4))
		_land_tiles.set_cell(32, _land_height, 0)
		_land_tiles.set_cell(31, _land_height, 0)
		for i in range(33 - val, 32):
			_land_tiles.set_cell(i, _land_height, 0)
		_land_tiles.update_bitmask_region(Vector2(-1, _land_height), Vector2(32, _land_height))
		
		if randf() < GameData.SPAWN_CHANCE and _land_height < GameData.PLATFORM_START:
			var p = _platform_scene.instance()
			p._coords.y = _land_height / 2
			var r = randf()
			if r > 0.5:
				p._coords.x = 2
				p.get_node("Sprite").position = Vector2(-38, 6)
				p.get_node("Sprite/Sprite2").position = Vector2(42, -1)
			else:
				p._coords.x = 13
				p.get_node("Sprite").flip_h = true
				p.get_node("Sprite").position = Vector2(-2, 6)
				p.get_node("Sprite/Sprite2").position = Vector2(16, -1)

			a_star.add_point(a_star_id, Vector3(p._coords.x, p._coords.y, 0))
			a_star2.add_point(a_star_id, Vector3(p._coords.x, p._coords.y, 0))
			a_star2.set_point_disabled(a_star_id, true)
			a_star.set_point_disabled(a_star_id, true)
			p.a_star_id = a_star_id
			a_star_id += 1
			p.position = p._coords * GameData.CELL_SIZE
			_platforms[p._coords] = p
			_buildings[p._coords] = p
			add_child(p)
			for i in range(GameData.PLATFORM_BONUS):
				p.agents.append(add_agent(p._coords, false))
		
		_land_height -= 1


func _on_Water_level_changed():
	for p in _platforms.keys():
		if p.y >= GameData.water_level:
			a_star.remove_point(_platforms[p].a_star_id)
			a_star2.remove_point(_buildings[p].a_star_id)
			_platforms.erase(p)
			_buildings.erase(p)

	print(GameData.water_level)

	for p in _buildings.keys():
		if p.y >= GameData.water_level:
			if a_star.has_point(_buildings[p].a_star_id):
				a_star.remove_point(_buildings[p].a_star_id)
			if a_star2.has_point(_buildings[p].a_star_id):
				a_star2.remove_point(_buildings[p].a_star_id)
			_buildings.erase(p)
	

func on_game_over():
	AudioManager.play("wave")
	$Water.stop()
	$Tween.interpolate_property($Water, "position:y", $Water.position.y, $Water.position.y - 144, 0.5, Tween.TRANS_QUAD, Tween.EASE_IN)
	$Tween.start()
	


## Debug Draw 
#func _draw() -> void:
#	for i in range(a_star_id - 1):
#		var connections = a_star2.get_point_connections(i)
#		var p1 = a_star2.get_point_position(i) * GameData.CELL_SIZE + Vector3(8, 8, 0)
#		for j in connections:
#			var p2 = a_star2.get_point_position(j) * GameData.CELL_SIZE + Vector3(8, 8, 0)
#			draw_line(Vector2(p1.x, p1.y), Vector2(p2.x, p2.y), Color(1, 1, 1, 1))
#



func _on_Tween_tween_all_completed():
	$UI.show_button()
