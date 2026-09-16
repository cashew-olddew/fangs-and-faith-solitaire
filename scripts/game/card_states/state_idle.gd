class_name IdleState
extends State

func handle_input(event: InputEvent) -> void:
	if not event.is_action_pressed("click"):
		return
	var query_parameter: PhysicsPointQueryParameters2D = PhysicsPointQueryParameters2D.new()
	query_parameter.position = event.position
	query_parameter.collide_with_areas = true

	var objects_clicked: Array[Dictionary] = owner.get_world_2d().direct_space_state.intersect_point(query_parameter)
	var filtered_objects_based_on_area = objects_clicked.filter(
		func(obj):
			return obj.collider.collision_layer == 2
	)
	filtered_objects_based_on_area.sort_custom(
		func(a: Dictionary, b: Dictionary) -> bool: return a.collider.get_parent().z_index < b.collider.get_parent().z_index
	)
	var colliders = filtered_objects_based_on_area.map(func(area): return area.collider)
	
	if filtered_objects_based_on_area[-1].collider.get_parent() == owner and owner._can_move():
		state_machine.change_state("InHand")

func update(_delta: float) -> void:
	pass

func enter(data := {}) -> void:
	pass

func exit() -> void:
	owner.current_placement = owner.global_position
