extends Node2D


var _paths: Dictionary = {
	Vector2.LEFT: null,
	Vector2.RIGHT: null,
	Vector2.UP: null,
	Vector2.DOWN: null,
}

var _coords: Vector2 = Vector2.ZERO


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


func update_links(coord: Vector2) -> void:
	pass


func construct(coord: Vector2, data: Dictionary) -> void:
	_coords = coord
	position = _coords * GameData.CELL_SIZE
	# Set valid paths
	_paths[Vector2.LEFT] = data.get(_coords + Vector2.LEFT)
	_paths[Vector2.RIGHT] = data.get(_coords + Vector2.RIGHT)
	_paths[Vector2.UP] = data.get(_coords + Vector2.UP)
	_paths[Vector2.DOWN] = data.get(_coords + Vector2.DOWN)
	
	# Update existing buildings with new entry
	data.get(_coords + Vector2.LEFT, self).update_links(_coords)
	data.get(_coords + Vector2.RIGHT, self).update_links(_coords)
	data.get(_coords + Vector2.UP, self).update_links(_coords)
	data.get(_coords + Vector2.DOWN, self).update_links(_coords)
