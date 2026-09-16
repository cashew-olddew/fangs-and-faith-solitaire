class_name InHandState
extends State

var click_position := Vector2.ZERO

func enter(_data := {}) -> void:
	click_position = owner.get_local_mouse_position() * owner.scale
	owner.start_floating()
	owner.emit_signal("card_is_moving", owner, true)
	
func update(_delta: float) -> void:
	owner.global_position = owner.get_global_mouse_position() - click_position

func handle_input(event: InputEvent) -> void:
	if event.is_action_released("click"):
		var closest_valid_area: Holder = get_closest_valid_area()
		if closest_valid_area:
			owner.emit_signal("card_is_released", owner)
			closest_valid_area._add_card(owner)

		state_machine.change_state("Returning", {"drop_area": closest_valid_area})

func exit() -> void:
	owner.emit_signal("card_is_moving", owner, false)
	pass

func get_closest_valid_area() -> Holder:
	var overlapping_areas: Array[Area2D] = owner.drag_area.get_overlapping_areas()

	var valid_areas = overlapping_areas.filter(
		func(holder): 
			if holder is Holder and holder != owner:
				return holder._can_place(owner)
	)

	if valid_areas:
		return get_closest_area(valid_areas)
	return null

func get_closest_area(valid_areas: Array[Area2D]):
	var closest_area = null
	var min_distance: float = INF
	
	for area in valid_areas:
		var distance: float = owner.global_position.distance_to(
			area.global_position
		)
		if distance < min_distance:
			min_distance = distance
			closest_area = area

	return closest_area
