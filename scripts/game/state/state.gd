class_name State
extends Node

var state_machine: StateMachine = null

func _ready():
	state_machine = get_parent()

func handle_input(_event: InputEvent) -> void:
	pass
	
func update(_delta: float) -> void:
	pass

func enter(_data := {}) -> void:
	pass

func exit() -> void:
	pass
