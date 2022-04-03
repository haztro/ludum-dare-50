extends Node


var CELL_SIZE = 16
var TOP_CAMERA_PAD = 16
enum Buildings {PATH = 0, HOUSE = 1}


var current_max_height: Vector2 = Vector2.ZERO


# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.



func update_max_height(coords: Vector2):
	if coords.y < current_max_height.y:
		current_max_height = coords
