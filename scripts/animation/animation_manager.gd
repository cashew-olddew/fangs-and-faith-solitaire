extends Node
class_name AnimationManager

@onready var spin_animation_manager: SpinManager = $SpinAnimationManager

var allow_unleash := true

# The functionality should be separated for different animations
@export var starting_position = Vector2.ZERO
var specials_unleashed_amount := 0

var special_cards: Array = []:
	set(card_array):
		for card in card_array:
			if card is SpecialCard:
				if not card.unleashed.is_connected(unleash.bind(card)):
					card.connect("unleashed", unleash.bind(card))
		special_cards = card_array
		spin_animation_manager.special_cards = card_array
	get:
		return special_cards

var normal_cards: Array = []:
	set(card_array):
		spin_animation_manager.cards_to_spin = card_array

func unleash(card: SpecialCard):
	if not allow_unleash:
		return
	specials_unleashed_amount += 1
	
	var overlay_manager: OverlayManager = get_tree().get_nodes_in_group("overlay").front()
	overlay_manager.toggle_darken(true)
	await get_tree().create_timer(0.2).timeout
	if specials_unleashed_amount == 2:
		await card.animation.play_unleash_animation(true)
	else:
		await card.animation.play_unleash_animation(false)
	await get_tree().create_timer(0.1).timeout
	card.state_machine.change_state("Active")
	overlay_manager.toggle_darken(false)
	specials_unleashed_amount -= 1

func are_unleash_animations_running() -> bool:
	return specials_unleashed_amount > 0

# BUG: Animation works, but if special card is on top, the unleash animation takes priority
func make_cards_fall(cards: Array) -> void:
	for card in cards:
		await get_tree().create_timer(randf()/10.0).timeout
		card.state_machine.change_state("Falling")
