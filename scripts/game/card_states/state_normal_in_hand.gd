class_name NormalInHandState
extends InHandState

func enter(data := {}) -> void:
	super.enter(data)
	
func update(delta: float) -> void:
	super.update(delta)

func handle_input(event: InputEvent) -> void:
	super.handle_input(event)

func exit() -> void:
	super.exit()
