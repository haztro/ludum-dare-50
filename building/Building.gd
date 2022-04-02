extends Node2D

signal camera_shake_request

var _paths: Dictionary = {
	Vector2.LEFT: null,
	Vector2.RIGHT: null,
	Vector2.UP: null,
	Vector2.DOWN: null,
}

var _coords: Vector2 = Vector2.ZERO
export(GameData.Buildings) var building_type = 0


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass


# Update the cell with the new connections. Change sprite etc. 
func update_links() -> void:
	pass
	
	
func set_path(dir: Vector2, building) -> void:
	_paths[dir] = building


func construct(coord: Vector2, data: Dictionary) -> void:
	_coords = coord
	position = _coords * GameData.CELL_SIZE
	# Set valid paths
	set_path(Vector2.LEFT, data.get(_coords + Vector2.LEFT))
	set_path(Vector2.RIGHT, data.get(_coords + Vector2.RIGHT))
	set_path(Vector2.UP, data.get(_coords + Vector2.UP))
	set_path(Vector2.DOWN, data.get(_coords + Vector2.DOWN))
	update_links()
	
	# Update existing buildings with new entry
	for p in _paths.keys():
		if _paths.get(p) != null:
			_paths[p].set_path(-p, self)
			_paths[p].update_links()
			
	emit_signal("camera_shake_request")

