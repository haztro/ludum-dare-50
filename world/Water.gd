extends Node2D

signal level_changed()

var time = 1.0

# Called when the node enters the scene tree for the first time.
func _ready():
#	var viewport_texture = get_viewport().get_texture()
#	$Buffer.texture = viewport_texture
	pass


func start_rise():
	$Timer.start()
	
func stop():
	$Timer.stop()


func _on_Timer_timeout():
	position.y -= GameData.RISE_RATE
	var water_level = floor((position.y - 94) / GameData.CELL_SIZE) - 2
	if water_level != GameData.water_level:
		GameData.water_level = water_level
		emit_signal("level_changed")
	
	$Timer.wait_time = time
	$Timer.start()


func _on_Timer2_timeout():
	time = max(0.1, time - 0.08)
