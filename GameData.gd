extends Node

signal game_over

var CELL_SIZE = 16
var TOP_CAMERA_PAD = 32
enum Buildings {PATH = 0, HOUSE = 1}
enum Agent {IDLE = 0, BUILD = 1, TRANSIT = 2}

var STARTING_POPULATION = 3
var START_PATHS = 3
var BUILD_RATE = 5
var PATH_BONUS = 5
var PLATFORM_BONUS = 3
var RISE_RATE = 1 # pixel per second
var SPAWN_CHANCE = 0.1
var PLATFORM_START = 2
var AGENT_TRANSIT_TIME = 16.0 / 50.0

var current_max_height: int = -1
var building_height: int = 11
var water_level: int = 8
var current_population: int = 0
var num_paths: int = 3

var running = true


# Called when the node enters the scene tree for the first time.
func _ready():
	pass


func restart():
	current_max_height = -1
	building_height = 11
	water_level = 8
	current_population = 0
	num_paths = 100
	running = true


func add_agent():
	current_population += 1
	
	
func kill_agent():
	current_population -= 1
	if current_population <= 0:
		running = false
		emit_signal("game_over")
		pass


func update_max_height(val: int):
	if val < current_max_height:
		current_max_height = val
		return true
	return false
		
		
func update_building_height(value: int):
	if value < building_height:
		building_height = value
