extends Node

@export var initial_state : State

var current_state : State
var states : Dictionary = {}

func _ready():
	for child in get_children():
		if child is State:
			states[child.name] = child
			child.transitioned.connect(on_child_transition)
			
	if initial_state:
		initial_state.Enter()
		current_state = initial_state
	
func _process(delta):
	if current_state:
		current_state.Update(delta)
	
func _physics_process(delta):
	if current_state:
		current_state.Physics_Update(delta)

func on_child_transition(curr_state, new_state_name):
	if curr_state != current_state:
		return
	
	var new_state = states.get(new_state_name)
	if !new_state:
		return
		
	if current_state:
		current_state.Exit()
		
	new_state.Enter()
	
	current_state = new_state
	
# function used to manually change state with a script outside of state group
func manual_state_change(curr_state, new_state_name):
	on_child_transition(curr_state, new_state_name)
