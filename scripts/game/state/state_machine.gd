class_name StateMachine
extends Node

@export var current_state: State
var states := {}

func _ready() -> void:
	for child in get_children():
		states[child.name] = child

func update(delta: float) -> void:
	if current_state:
		current_state.update(delta)
		
func handle_input(event: InputEvent) -> void:
	if current_state:
		current_state.handle_input(event)
	
func change_state(new_state_name: String, data := {}) -> void:
	if current_state:
		current_state.exit()

	current_state = states.get(new_state_name)
	
	if data:
		current_state.enter(data)
	else:
		current_state.enter({"msg": str("Entered state: ", current_state)})
