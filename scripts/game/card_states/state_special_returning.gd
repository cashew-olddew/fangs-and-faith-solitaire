class_name SpecialReturnState
extends ReturnState

func enter(data := {}):
	
	await tween_to_snapping_point(data)
	
	var dropped_on_special_zone = data.drop_area == owner.corresponding_zone
	var was_previously_active = owner.current_placement == owner.corresponding_zone.global_position
		
	if  (data.drop_area and dropped_on_special_zone) or (not data.drop_area and was_previously_active):
		state_machine.change_state("Active", data)
		SoundManager.play_sound(owner.special_effect_sounds[owner.suit]["unleash"])
	else:
		state_machine.change_state("Idle", data)
		if data.drop_area:
			SoundManager.play_sound("Card_Move")
		else:
			SoundManager.play_sound("Card_Discard")

func handle_input(event: InputEvent) -> void:
	super.handle_input(event)

func exit() -> void:
	super.exit()
