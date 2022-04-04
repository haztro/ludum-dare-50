extends "res://building/Building.gd"


var percent_built = 0
var buildings = {}
var buildables = {}

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


func construct(coord: Vector2, data: Dictionary, buildable: Dictionary) -> void:
	_coords = coord
	position = _coords * GameData.CELL_SIZE
	buildings = data
	buildables = buildable

	# Set valid paths
	set_path(Vector2.LEFT, data.get(_coords + Vector2.LEFT))
	set_path(Vector2.RIGHT, data.get(_coords + Vector2.RIGHT))
	set_path(Vector2.UP, data.get(_coords + Vector2.UP))
	set_path(Vector2.DOWN, data.get(_coords + Vector2.DOWN))
	update_links()
	
	# Add point for pathfinding
	a_star.add_point(a_star_id, Vector3(_coords.x, _coords.y, 0))
	a_star2.add_point(a_star_id, Vector3(_coords.x, _coords.y, 0))
	
	if building_type == GameData.Buildings.PATH:
		a_star2.set_point_disabled(a_star_id, true)
	
	buildable.erase(_coords)
	
	# Update existing buildings with new entry
	for p in _neighbours.keys():
		if _neighbours.get(p) != null:
			# Make new connections for pathfinding
			if !a_star.are_points_connected(a_star_id, _neighbours[p].a_star_id):
				if !(building_type == GameData.Buildings.HOUSE and _neighbours[p].building_type == GameData.Buildings.HOUSE):
					a_star.connect_points(a_star_id, _neighbours[p].a_star_id)
					a_star2.connect_points(a_star_id, _neighbours[p].a_star_id)
				
			_neighbours[p].set_path(-p, self)
			_neighbours[p].update_links()
			if buildable.has(_coords + p): buildable.erase(_coords + p)
			
	emit_signal("camera_shake_request")



func build():
	percent_built = min(100, percent_built + GameData.BUILD_RATE)
	if percent_built < 25:
		$Sprite.region_rect.position.x = 0
	elif percent_built < 50:
		$Sprite.region_rect.position.x = 17
	elif percent_built < 75:
		$Sprite.region_rect.position.x = 17 * 2
	elif percent_built < 100:
		$Sprite.region_rect.position.x = 17 * 3
	else:
		build_finished()


func build_finished():
	AudioManager.play("built")
	$Sprite.region_rect.position.x = 17 * 4
	a_star2.set_point_disabled(a_star_id, true)
	
	GameData.num_paths += GameData.PATH_BONUS

	# Update existing buildings with new entry
	for p in _neighbours.keys():
		if _neighbours.get(p) != null:
			pass
		else:
			buildables[_coords + p] = null
	
	

