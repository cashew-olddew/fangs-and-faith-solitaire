class_name UnleashedState
extends State

func handle_input(event: InputEvent) -> void:
	pass

func update(_delta: float) -> void:
	pass

func enter(_data := {}) -> void:
	owner.start_floating()
	owner.animation.initial_placement = owner.current_placement
	owner.current_placement = owner.corresponding_zone.global_position
	owner.is_unleashed = true
	owner.emit_signal("unleashed")
