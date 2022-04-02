extends "res://building/Building.gd"


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.



func update_links() -> void:
	if _paths[Vector2.UP] == null:
		$Sprite.region_rect.position.x = 0
	else:
		if _paths[Vector2.DOWN] != null:
			if _paths[Vector2.DOWN].building_type == GameData.Buildings.PATH:
				$Sprite.region_rect.position.x = 16
			elif _paths[Vector2.DOWN].building_type == GameData.Buildings.HOUSE:
				$Sprite.region_rect.position.x = 32
		else:
			$Sprite.region_rect.position.x = 32
