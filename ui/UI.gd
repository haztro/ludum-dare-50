extends CanvasLayer


onready var ppl_label = get_node("Control/MarginContainer/VBoxContainer/HBoxContainer/Label")
onready var path_label = get_node("Control/MarginContainer/VBoxContainer/HBoxContainer2/Label2")
onready var height_label = get_node("Control/Label3")

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	ppl_label.text = str(GameData.current_population)
	path_label.text = str(GameData.num_paths)
	height_label.text = str((GameData.building_height - 6) * 5) + "m"
	
	
func show_button():
	$Control/Button.disabled = false
	$Control/Button.visible = true
#	pass

func _on_Button_pressed():
	GameData.restart()
	get_tree().change_scene("res://world/World.tscn")
