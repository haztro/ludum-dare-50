extends "res://building/Building.gd"


signal vacancy(coord, a_star_id)



# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


func construct(coord: Vector2, data: Dictionary, buildable: Dictionary) -> void:
	.construct(coord, data, buildable)
	emit_signal("vacancy", coord, a_star_id)



func add_occupant(occupant) -> void:
	if get_num_occupants() < GameData.HOUSE_CAPACITY:
		.add_occupant(occupant)
#		if get_num_occupants() == GameData.HOUSE_CAPACITY:
###			a_star.set_point_disabled(a_star_id, true)
#			a_star2.set_point_disabled(a_star_id, true)
	else:
		occupant.go_back()
		occupant.set_state(GameData.Agent.SEARCH)


func remove_occupant(occupant) -> void:
	if get_num_occupants() == GameData.HOUSE_CAPACITY:
		emit_signal("vacancy", _coords, a_star_id)
		
	.remove_occupant(occupant)
#	if get_num_occupants() < GameData.HOUSE_CAPACITY:
##		a_star.set_point_disabled(a_star_id, false)
#		a_star2.set_point_disabled(a_star_id, false)
