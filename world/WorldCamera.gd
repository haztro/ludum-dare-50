extends Camera2D

export(float) var amplitude = 6
export(float) var duration = 0.1
var shake = 0
var timer = Timer.new()
var direction: Vector2 = Vector2.ZERO
var velocity: Vector2 = Vector2.ZERO
var move = preload("res://shared/Move2D.gd").new(100, 50)

var top_lim = 0

func _ready():
	timer.connect("timeout", self, "_on_Timer_timeout")
	timer.one_shot = true
	add_child(timer)
	
	
func _process(_delta):
	shake_camera()
	get_direction()
	
#	top_lim = GameData.current_max_height.y * GameData.CELL_SIZE - GameData.TOP_CAMERA_PAD
#	limit_bottom = get_parent().get_node("Water").position.y
	
	if GameData.running:
		velocity = move.get_velocity(direction)
		position += velocity * _delta
		
		if position.y - get_parent().get_node("Water").position.y > -100:
			position.y -= (position.y - get_parent().get_node("Water").position.y + 100) * 0.5


# Get movement direction from key presses
func get_direction() -> void:
	direction = Vector2(0, 0)
#	if Input.is_action_pressed("right"):
#		direction.x += 1
#	if Input.is_action_pressed("left"):
#		direction.x -= 1
	if Input.is_action_pressed("down"):
		direction.y += 1
	if Input.is_action_pressed("up"):
		direction.y -= 1
#
#	if position.y > limit_bottom/2:
#		direction.y = -1
#	elif position.y < limit_top + get_viewport().size.y / 2:
#		direction.y = 1
		
	direction = direction.normalized()
	

func shake_camera():
	offset = shake * Vector2(rand_range(-1, 1), rand_range(-1, 1))
		
		
func _camera_shake_requested():
	shake = amplitude
	if !timer.is_stopped():
		timer.wait_time += duration
	else:
		timer.wait_time = duration
		timer.start()
		
		
func _on_Timer_timeout():
	shake = 0
		

