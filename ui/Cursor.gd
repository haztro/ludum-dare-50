extends Node2D


var _coords: Vector2 = Vector2.ZERO
var _valid_move = true


# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


func update_cursor(coord: Vector2, data: Dictionary, force=false) -> void:
	if force or coord != _coords:
		_coords = coord
		position = _coords * GameData.CELL_SIZE
		if !data.has(_coords):
			$Sprite.modulate = Color(0.757813, 0.156891, 0.156891)
			_valid_move = false
		else:
			$Sprite.modulate = Color(0, 0, 0)
			_valid_move = true


func is_valid_build() -> bool:
	return _valid_move
