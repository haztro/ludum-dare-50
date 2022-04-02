extends "res://building/Building.gd"


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.



func update_links() -> void:
	
	if _paths[Vector2.UP] != null:
		$Sprite.region_rect.position.x = 48
	else:
		$Sprite.region_rect.position.x = 0
	
	# Side connections
	if _paths[Vector2.LEFT] != null and _paths[Vector2.RIGHT] != null:
		pass
	elif _paths[Vector2.LEFT] == null and _paths[Vector2.RIGHT] != null:
		$Sprite.region_rect.position.x += 16
	elif _paths[Vector2.LEFT] != null and _paths[Vector2.RIGHT] == null:
		$Sprite.region_rect.position.x += 32
	elif _paths[Vector2.LEFT] == null and _paths[Vector2.RIGHT] == null:
		$Sprite.region_rect.position.x = 96
		

