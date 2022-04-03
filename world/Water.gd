extends Node2D


# Declare member variables here. Examples:
# var a = 2
# var b = "text"


# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.



func start_rise():
	$Timer.start()


func _on_Timer_timeout():
	position.y -= GameData.RISE_RATE
	$Timer.start()
