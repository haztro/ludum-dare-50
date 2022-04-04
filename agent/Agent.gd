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
var building = null
var build_search = false

var registered = false

# Called when the node enters the scene tree for the first time.
func _ready():
	if randf() > 0.5:
		$Sprite.position.x -= 1


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	if _coords.y > GameData.water_level - 1:
		if registered:
			GameData.kill_agent()
		queue_free()
	

func find_random() -> void:
	if buildings.size() <= 0:
		state = GameData.Agent.IDLE
		return
	var random_pos = buildings.keys()[randi() % buildings.size()]
	if !buildings.has(random_pos):
		state = GameData.Agent.IDLE
		return
		
	var id = buildings[random_pos].a_star_id
	
	if !a_star.has_point(id):
		state = GameData.Agent.IDLE
		return
		
	var dest_3d = a_star.get_point_position(id)
	search(dest_3d, id)
	
	
func search(coord: Vector3, id: int):
	# Get closest empty house
#	var id = get_destination()
	if !a_star.has_point(id):
		state = GameData.Agent.IDLE
		return
		
	var dest_3d = a_star.get_point_position(id)

	if id == -1 or _in_transit:
		return
		
	# Looks pretty bad but still better than diagonal travel
	$Tween.stop_all()
	position = _coords * GameData.CELL_SIZE + Vector2(floor(randf() * 4.0 - 2), 0)
	_path_index = 0		
	dest_id = id
	
	_path = get_transit_path(dest_id)
	if _path.size() == 0:
		return
		
	_dest = Vector2(dest_3d.x, dest_3d.y)
	yield(get_tree().create_timer(randf()), "timeout")
	move()
	_path_index += 1

	
func get_transit_path(dest_id: int) -> Array:
	if !buildings.has(_coords):
		state = GameData.Agent.IDLE
		return []
		
	var current_id = buildings[_coords].a_star_id
	if !a_star.has_point(current_id) or !a_star.has_point(dest_id):
		state = GameData.Agent.IDLE
		return []
		
	var path = a_star.get_id_path(current_id, dest_id)
	_path_index = 0
	return path
	
	
func move():
	_in_transit = true
	if !a_star.has_point(_path[_path_index]):
		state = GameData.Agent.IDLE
		return 
	var pd = a_star.get_point_position(_path[_path_index])
	_partial_dest = Vector2(pd.x, pd.y)
	partial_dest_id = _path[_path_index]
	
	$Tween.interpolate_property(self, "position", position, _partial_dest * GameData.CELL_SIZE, GameData.AGENT_TRANSIT_TIME, 0, 0)
	$Tween.start()
	
	
func _on_Tween_tween_all_completed():
	_coords = _partial_dest
	
	# Still haven't finished path
	if position != _dest * GameData.CELL_SIZE:
		move()
		_path_index += 1
	else:
		_in_transit = false
		if build_search and buildings[_coords].building_type == GameData.Buildings.HOUSE:
			building = buildings[_coords]
			state = GameData.Agent.BUILD
		else:
			state = GameData.Agent.IDLE


func _on_Timer_timeout():
	match state:
		GameData.Agent.IDLE:
			var id = a_star2.get_closest_point(Vector3(_coords.x, _coords.y, 0), false)
			if id == -1:
				find_random()
			else:
				var p = a_star2.get_point_position(id)
				search(p, id)
				if buildings[Vector2(p.x, p.y)].building_type == GameData.Buildings.HOUSE:
					build_search = true
#			state = GameData.Agent.TRANSIT
				
		GameData.Agent.BUILD:
			if building != null and building.percent_built != 100:
				building.build()
			elif building.percent_built == 100:
				build_search = false
				state = GameData.Agent.IDLE
				building = null
				
		GameData.Agent.TRANSIT:
			pass
			
			
			
