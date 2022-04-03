extends Node2D

var buildings = null
var a_star = null
var a_star2 = null
var _coords = Vector2.ZERO
var state: int = GameData.Agent.IDLE

var _path: Array = []
var _path_index: int = 0

var _dest: Vector2 = Vector2.ZERO
var _partial_dest: Vector2 = Vector2.ZERO
var _in_transit = false

var dest_id: int = 0
var partial_dest_id: int = 0
var climbing = false
var building = null
var last_pos = Vector2.ZERO



# Called when the node enters the scene tree for the first time.
func _ready():
	pass


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
#	print(building)
	pass
	

func set_state(new_state: int) -> void:
	match new_state:
		GameData.Agent.IDLE:
			_in_transit = false
			$Tween.stop_all()
		GameData.Agent.SEARCH:
			_in_transit = false
			find_random()
		GameData.Agent.TRANSIT:
			pass
	state = new_state
	

func find_random() -> void:
	var random_pos = buildings.keys()[randi() % buildings.size()]
	var id = buildings[random_pos].a_star_id
	var dest_3d = a_star.get_point_position(id)
	search(Vector2(dest_3d.x, dest_3d.y), id, true)
	
	
func search(coord: Vector2, id: int, recalc=false):
	# Get closest empty house
#	var id = get_destination()
	var dest_3d = a_star.get_point_position(id)

	# See if building is higher up
	if !recalc and building != null:
		if dest_3d.y >= _coords.y:
			return
	
	if !recalc and (id == -1 or _in_transit):
		return
		
	# Looks pretty bad but still better than diagonal travel
	$Tween.stop_all()
	position = _coords * GameData.CELL_SIZE
	_path_index = 0		
	dest_id = id
	traverse_path(dest_3d, id)


func traverse_path(dest_coord, dest_id) -> void:
	# We have a destination so now calculate the path and start moving.
	_path = get_transit_path(dest_id)
	if _path.size() == 0:
		set_state(GameData.Agent.SEARCH)
		return
		
	set_state(GameData.Agent.TRANSIT)
	_dest = Vector2(dest_coord.x, dest_coord.y)
	move()
	_path_index += 1
	

func get_destination() -> int:
	var dest_id = a_star2.get_closest_point(Vector3(_coords.x, _coords.y, 0))
	return dest_id
	
	
func get_transit_path(dest_id: int) -> Array:
	var current_id = buildings[_coords].a_star_id
	var path = a_star.get_id_path(current_id, dest_id)
	_path_index = 0
	return path
	
	
func move():
	_in_transit = true
	var pd = a_star.get_point_position(_path[_path_index])
	_partial_dest = Vector2(pd.x, pd.y)
	partial_dest_id = _path[_path_index]
	
	climbing = _coords.y != _partial_dest.y
	$Tween.interpolate_property(self, "position", position, _partial_dest * GameData.CELL_SIZE, GameData.AGENT_TRANSIT_TIME, 0, 0)
	$Tween.start()
	buildings[_coords].add_occupant(self)
	
	
func go_back():
	_coords = last_pos
	position = _coords * GameData.CELL_SIZE
	$Tween.stop_all()


func _on_Tween_tween_all_completed():
	buildings[_coords].remove_occupant(self)
	last_pos = _coords
	_coords = _partial_dest
	
	# Still haven't finished path
	if position != _dest * GameData.CELL_SIZE:
		move()
		_path_index += 1
	else:
		set_state(GameData.Agent.IDLE)
		_in_transit = false
		buildings[_coords].add_occupant(self)
