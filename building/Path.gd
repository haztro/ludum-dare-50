extends "res://building/Building.gd"


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
		
	if randf() > 0.5:
		$Sprite.region_rect.position.y = 17
	else:
		$Sprite.region_rect.position.y = 0


