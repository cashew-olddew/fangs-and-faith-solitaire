extends Node

signal special_card_added(special_card: SpecialCard, character: Utils.Suit)
signal card_collected

func generate_deck():
	generate_normal_cards()
	var game_mode = owner.game_settings.game_mode
	if game_mode == "0":
		generate_special_cards()

func generate_normal_cards() -> void:
	var cards_per_suit = 13
	match owner.game_settings.difficulty:
		"0":
			cards_per_suit = ceil(2 * owner.game_settings.rows)
		"1":
			cards_per_suit = ceil(2.5 * owner.game_settings.rows)
		"2":
			cards_per_suit = ceil(2.76 * owner.game_settings.rows)
		_:
			cards_per_suit = 13
	for suit in Utils.Suit:
		for i in range(cards_per_suit):
			var normal_card: NormalCard = NormalCard.get_instance(i + 1, suit)
			add_child(normal_card)
			var node_name = "NormalCard{0}{1}".format([
				Utils.capitalize_first_letter(suit),
				Utils.capitalize_first_letter(str(i + 1))])
			normal_card.set_name(node_name)

func generate_special_cards() -> void:
	for character in Utils.Suit:
		var special_card: SpecialCard = SpecialCard.get_instance(character)
		add_child(special_card)
		special_card_added.emit(special_card, character)
		var node_name = "SpecialCard{0}".format([Utils.capitalize_first_letter(character)])
		special_card.set_name(node_name)
