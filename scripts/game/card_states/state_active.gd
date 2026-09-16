class_name ActiveState
extends IdleState

func handle_input(event: InputEvent) -> void:
	super.handle_input(event)

func update(_delta: float) -> void:
	pass

func enter(_data := {}) -> void:
	owner.toggle_marked_card_particles(true)
	owner.stop_floating()

func exit() -> void:
	owner.toggle_marked_card_particles(false)
