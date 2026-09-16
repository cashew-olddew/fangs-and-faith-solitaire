extends Node
class_name TransformationManager

var normal_cards: Array
var special_cards: Dictionary

func initialize(normal_cards: Array, special_cards: Dictionary):
	self.normal_cards = normal_cards
	self.special_cards = special_cards
	
	for card in special_cards.values():
		card.connect("looking_for_target", set_marked_card.bind(card))
		set_marked_card(card)

func handle_card_collected(card: NormalCard) -> void:
	# if the next targeted card is collected, don't apply any effects, find a new target
	for special_card: SpecialCard in special_cards.values():
		if card == special_card.marked_card:
			free_collected_card(special_card)
			
func free_collected_card(special_card: SpecialCard) -> void:
	special_card.free_normal_card()

func apply_special_card_effects() -> void:
	for special_card: SpecialCard in special_cards.values():
		special_card.apply_special_card_effects()

func set_marked_card(special_card: SpecialCard) -> void:
	var transformable_cards = normal_cards.filter(
		func(card: NormalCard): return card.suit != special_card.suit and not card.is_collected()
	)

	if not transformable_cards.is_empty():
		special_card.mark_normal_card(transformable_cards.pick_random())
	# TODO: else animate the special card to show that there are no other cards to transform
