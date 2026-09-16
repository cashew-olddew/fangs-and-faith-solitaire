class_name ReturnState
extends State

func enter(data := {}):
	await tween_to_snapping_point(data)
	play_sound(data)
	state_machine.change_state("Idle", data)

func handle_input(_event: InputEvent) -> void:
	pass

func exit() -> void:
	owner.stop_floating()
	
func tween_to_snapping_point(data):
	if data.drop_area:
		owner.current_placement = data.drop_area._get_snapping_point()

	var tween = create_tween().tween_property(
		owner,
		"global_position",
		owner.current_placement,
		0.2
	).set_ease(Tween.EASE_IN).set_trans(Tween.TRANS_SINE)
		
	await tween.finished

func play_sound(data) -> void:
	var sound = "Card_Move" if data.drop_area else "Card_Discard"
	SoundManager.play_sound(sound)
