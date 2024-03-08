class_name StateMachine
extends Node

@export var starting_state: State

var states: Array[State] =[]
var current_state: State = starting_state

func _ready():
	for child in get_children():
		states.append(child as State)
		child.state_machine = self

func _process(delta):
	current_state.update(delta)

func change_state_to(state_name: String, args := {}) -> void:
	current_state.exit()
	current_state = get_node(state_name)
	current_state.enter(args)
