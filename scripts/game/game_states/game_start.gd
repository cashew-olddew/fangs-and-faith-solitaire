class_name GameStartState
extends State

func _ready():
	state_machine = get_parent()

func enter(_data := {}) -> void:
	var o: BoardManager = owner
	o.game_state_changed.emit(name)
	o.input_blocker.set_visible(true)
	
	o.zone_manager.initialize_zones()
	o.deck_manager.generate_deck()
	
	o.zones = o.zone_manager.normals.get_children()
	o.metals = o.zone_manager.metals.get_children()
	var all_cards = o.deck_manager.get_children()
	for card in all_cards:
		card.global_position = o.animation_manager.starting_position
	o.normal_cards = o.get_normal_cards(all_cards)
	o.special_cards = o.get_special_cards(all_cards)
	var shuffled_cards = o.shuffle_cards(o.normal_cards, o.special_cards)
	
	o.animation_manager.normal_cards = o.normal_cards
	o.animation_manager.special_cards = o.special_cards.values()
	o.listen_to_normal_card_events()
	o.listen_to_special_card_events()
	
	o.transformation_manager.initialize(o.normal_cards, o.special_cards)
	
	o.distribute_cards(shuffled_cards)
	await o.position_cards_on_zones()

	#state_machine.change_state("GameOver")
	#state_machine.change_state("GameWon")
	state_machine.change_state("GamePlay")
