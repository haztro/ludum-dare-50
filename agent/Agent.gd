extends Node2D

class Brain:
	var current_state = GameData.Agent.SEARCH
	var states: Dictionary = {}
	
	func _init(new_agent):
		states[GameData.Agent.IDLE] = StateIdle.new(new_agent)
		states[GameData.Agent.SEARCH] = StateSearch.new(new_agent)
		states[GameData.Agent.TRANSIT] = StateTransit.new(new_agent)
		set_state(current_state)
	
	func set_state(new_state: int):
		states[current_state].exit_actions()
		current_state = new_state
		states[current_state].entry_actions()
			
	func think():
		var new_state = states[current_state].actions()
		if new_state != current_state:
			set_state(new_state)
		
		
class State:
	var state: int = 0
	var agent = null
	var dest_coord = Vector2.ZERO
	
	func entry_actions():
		pass
		
	func exit_actions():
		pass
		
	func actions():
		pass
		
		
class StateIdle extends State:
	
	func _init(new_agent):
		agent = new_agent
		state = GameData.Agent.IDLE
	
	func entry_actions():
		pass
		
	func exit_actions():
		pass
		
	func actions():
		pass
		
		
class StateSearch extends State:
	
	func _init(new_agent):
		agent = new_agent
		state = GameData.Agent.SEARCH
	
	func entry_actions():
		dest_coord = agent.a_star_houses.get_closest_point(Vector3(agent._coord.x, agent._coord.y, 0), true)
		var current_id = agent.buildings[agent.coord].a_star_id
		var dest_id = agent.buildings[dest_coord].a_star_id
		agent._path = agent.a_star_houses.get_point_path(current_id, dest_id)
		
	func exit_actions():
		pass
		
	func actions():
		pass
		
		
class StateTransit extends State:
	func _init(new_agent):
		agent = new_agent
		state = GameData.Agent.TRANSIT
	
	func entry_actions():
		pass
		
	func exit_actions():
		pass
		
	func actions():
		pass
		

var buildings = null
var a_star_path = null
var a_star_houses = null
var _coord = Vector2.ZERO
var brain = Brain.new(self)

var _path: Array = []


# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass
