extends "res://building/Building.gd"

var climbing: Array = []

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.



func update_links() -> void:
	
	if _neighbours[Vector2.UP] != null:
		$Sprite.region_rect.position.x = 48
	else:
		$Sprite.region_rect.position.x = 0
	
	# Side connections
	if _neighbours[Vector2.LEFT] != null and _neighbours[Vector2.RIGHT] != null:
		pass
	elif _neighbours[Vector2.LEFT] == null and _neighbours[Vector2.RIGHT] != null:
		$Sprite.region_rect.position.x += 16
	elif _neighbours[Vector2.LEFT] != null and _neighbours[Vector2.RIGHT] == null:
		$Sprite.region_rect.position.x += 32
	elif _neighbours[Vector2.LEFT] == null and _neighbours[Vector2.RIGHT] == null:
		$Sprite.region_rect.position.x = 96
		
		
#func add_occupant(occupant) -> void:
#	.add_occupant(occupant)
#	if occupant.climbing:
#		if climbing.size() < GameData.LADDER_CAPACITY:
#			climbing.append(occupant)
#			if climbing.size() == GameData.LADDER_CAPACITY:
#				a_star.disconnect_points(occupant.partial_dest_id, a_star_id)
#		else:
#			.remove_occupant(occupant)
#			climbing.erase(occupant)
#			print("HERE")
#			occupant.search(occupant._dest, occupant.dest_id, true) 
#
#
#func remove_occupant(occupant) -> void:
#	.remove_occupant(occupant)
#	if occupant.climbing:
#		if climbing.size() == GameData.LADDER_CAPACITY:
#			a_star.connect_points(occupant.partial_dest_id, a_star_id)
#		climbing.erase(occupant)
	

