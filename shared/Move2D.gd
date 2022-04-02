extends Node

var _velocity = Vector2.ZERO
var _max_speed
var _acceleration

func _init(max_speed, acceleration):
	_max_speed = max_speed
	_acceleration = acceleration
	
func get_velocity(direction):
	if direction == Vector2.ZERO:
		apply_friction()
	else:
		apply_acceleration(direction)
		
	return _velocity

func apply_friction():
	if _velocity.length() > _acceleration:
		_velocity -= _velocity.normalized() * _acceleration
	else:
		_velocity = Vector2.ZERO

func apply_acceleration(direction):
	_velocity += _acceleration * direction
	_velocity = _velocity.clamped(_max_speed)
