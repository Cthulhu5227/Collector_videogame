extends Node

@export var initial_state : EnemyState

var cur_state : EnemyState
var states : Dictionary = {}

func _ready():
	for child in get_children():
		if child is EnemyState:
			states[child.name.to_lower()] = child
			child.transitioned.connect(on_child_transition)
	
	if initial_state:
		initial_state.enter()
		cur_state = initial_state

func _process(delta):
	if cur_state:
		cur_state.update(delta)
		
func _physics_process(delta):
	if cur_state:
		cur_state.physics_update(delta)
		
func on_child_transition(state, new_state_name):
	if state != cur_state:
		return
	
	var new_state = states.get(new_state_name.to_lower())
	if !new_state:
		return
	
	if cur_state:
		cur_state.exit()
		
	new_state.enter()
	cur_state = new_state
