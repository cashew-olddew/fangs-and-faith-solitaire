class_name CollectedState
extends State

func handle_input(_event: InputEvent) -> void:
	pass
	
func update(_delta: float) -> void:
	pass

func enter(data := {}) -> void:
	if owner.left_neighbor:
		owner.current_placement = owner.left_neighbor.global_position + Vector2.UP * 2.5
	else:
		owner.current_placement = data.drop_area.global_position

	owner.start_floating()
	var tween = create_tween().tween_property(
		owner,
		"global_position",
		owner.current_placement,
		0.2
	).set_ease(Tween.EASE_IN).set_trans(Tween.TRANS_SINE)
		
	await tween.finished
	owner.stop_floating()
	owner.finished_collected_animation = true
	owner.emit_signal("card_collected", owner)
	
	SoundManager.play_sound("Card_Collect")

func exit() -> void:
	pass
