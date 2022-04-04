extends Node2D


var _coords: Vector2 = Vector2.ZERO
var a_star_id: int = 0
var building_type = GameData.Buildings.PATH
var agents = []

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Update the cell with the new connections. Change sprite etc. 
func update_links() -> void:
	pass
	
	
func set_path(dir: Vector2, building) -> void:
	pass


func construct():
	pass
	
	
func hide_mark():
	$Timer.stop()
	$Sprite/Sprite2.visible = false


func _on_Timer_timeout():
	$Timer.wait_time = randf() + 1.0 * 2
	$Sprite/Sprite2.visible = !$Sprite/Sprite2.visible
