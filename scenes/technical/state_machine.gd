class_name StateMachine
extends Node

@export var starting_state: State
## this is the node that the state machine controls
## [br] it doesn't have to actually be a character, but is called this because I 
## couldn't think of a better name
@export var character: Character

var states: Array[State] =[]
var current_state: State

func _ready():
	current_state = starting_state
	for child in get_children():
		states.append(child as State)
		child.state_machine = self
		child.character = character
	
	current_state.enter()

func _process(delta):
	current_state.update(delta)

## changes the current state to the one specified by its name
func change_state_to(state_name: String, args := {}) -> void:
	print("Changing state from ", current_state.state_name, " to ", state_name)
	if has_node(state_name):
		current_state.exit()
		current_state = get_node(state_name)
		current_state.enter(args)
	else:
		print("ERROR, state ", state_name, " not found!")
