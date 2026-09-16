class_name NormalIdleState
extends IdleState

func handle_input(event: InputEvent) -> void:
	super.handle_input(event)

func update(delta: float) -> void:
	super.update(delta)

func enter(data := {}) -> void:
	owner.emit_signal("card_settled", data.drop_area)
	super.enter(data)

func exit() -> void:
	super.exit()
