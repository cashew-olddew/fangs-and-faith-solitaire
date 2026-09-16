class_name NormalReturnState
extends ReturnState

func enter(data := {}):
	if data.drop_area:
		if data.drop_area is CollectorZone \
			or (data.drop_area is NormalCard \
			and data.drop_area.state_machine.current_state is CollectedState):
			state_machine.change_state("Collected", {"drop_area": data.drop_area})
			return
		owner.current_placement = data.drop_area._get_snapping_point()

	super.enter(data)

func handle_input(event: InputEvent) -> void:
	super.handle_input(event)

func exit() -> void:
	super.exit()
