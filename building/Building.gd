extends Node2D

signal camera_shake_request

var _neighbours: Dictionary = {
	Vector2.LEFT: null,
	Vector2.RIGHT: null,
	Vector2.UP: null,
	Vector2.DOWN: null,
}

var _paths: Dictionary = {}

var _coords: Vector2 = Vector2.ZERO
export(GameData.Buildings) var building_type = 0

var a_star
var a_star_id: int = 0

var occupants: Array = []


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass


# Update the cell with the new connections. Change sprite etc. 
func update_links() -> void:
	pass
	
	
func set_path(dir: Vector2, building) -> void:
	_neighbours[dir] = building


func construct(coord: Vector2, data: Dictionary, buildable: Dictionary, a_star, a_star_houses) -> void:
	_coords = coord
	position = _coords * GameData.CELL_SIZE
	# Set valid paths
	set_path(Vector2.LEFT, data.get(_coords + Vector2.LEFT))
	set_path(Vector2.RIGHT, data.get(_coords + Vector2.RIGHT))
	set_path(Vector2.UP, data.get(_coords + Vector2.UP))
	set_path(Vector2.DOWN, data.get(_coords + Vector2.DOWN))
	update_links()
	
	# Add point for pathfinding
	a_star.add_point(a_star_id, Vector3(_coords.x, _coords.y, 0))
	if building_type == GameData.Buildings.HOUSE:
		a_star_houses.add_point(a_star_id, Vector3(_coords.x, _coords.y, 0))
	
	buildable.erase(_coords)
	
	# Update existing buildings with new entry
	for p in _neighbours.keys():
		if _neighbours.get(p) != null:
			# Make new connections for pathfinding
			if !a_star.are_points_connected(a_star_id, _neighbours[p].a_star_id):
				a_star.connect_points(a_star_id, _neighbours[p].a_star_id)
				
			_neighbours[p].set_path(-p, self)
			_neighbours[p].update_links()
			if buildable.has(_coords + p): buildable.erase(_coords + p)
		else:
			buildable[_coords + p] = null
			
	emit_signal("camera_shake_request")


func get_num_occupants() -> int:
	return occupants.size()


func add_occupant(occupant) -> void:
	pass
	
	
func remove_occupant(occupant) -> void:
	pass
