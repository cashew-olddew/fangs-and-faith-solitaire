extends Node2D
class_name BoardManager

@onready var zone_manager = $ZoneManager
@onready var deck_manager = $DeckManager
@onready var animation_manager: AnimationManager = $AnimationManager
@onready var transformation_manager: TransformationManager = $TransformationManager
@onready var drawer: Node2D = $Drawer

@onready var input_blocker: Panel = $InputBlocker
@onready var state_machine: StateMachine = $StateMachine

var zones: Array
var metals: Array
var normal_cards: Array
var special_cards: Dictionary

var game_settings: GameSettings = SaveManager.get_game_settings()

signal game_state_changed(state: String)

func _ready():
	state_machine.change_state("GameStart")

func get_normal_cards(cards: Array) -> Array:
	return cards.filter(func(card): return card is NormalCard)

# DK why but this is a dictionary and I am afraid to change it so I changed down
func get_special_cards(cards: Array) -> Dictionary:
	return (
		cards.filter(func(card): return card is SpecialCard)
		.reduce(
			func(acc, special_card):
			acc[special_card.suit] = special_card
			return acc
			, {}))

func shuffle_cards(normal_cards: Array, special_cards: Dictionary) -> Array:
	# Copy array to avoid mutation
	var cards_reordered = normal_cards.duplicate(true)
	
	# Find a random card
	var random_card: NormalCard = cards_reordered.pick_random()
	cards_reordered.erase(random_card)
	
	# Find a consecutive number of different suit
	var card_for_sequence_index: int
	var card_for_sequence: NormalCard
	var consecutive_number: int = random_card.number - 1 if random_card.number > 1 else 2
	for card_index in len(cards_reordered):
		var is_consecutive_card = cards_reordered[card_index].number == consecutive_number \
			and cards_reordered[card_index].suit != random_card.suit
		if is_consecutive_card:
			card_for_sequence_index = card_index
			card_for_sequence = cards_reordered[card_index]
			break
	cards_reordered.remove_at(card_for_sequence_index)
	
	# Shuffle all cards and append the picked sequence at the and to ensure a first move
	cards_reordered.append_array(special_cards.values())
	cards_reordered.shuffle()
	cards_reordered.append(random_card)
	cards_reordered.append(card_for_sequence)
	return cards_reordered

func distribute_cards(cards: Array):
	var zone_indexes = range(zones.size())
	var shuffled_cards = cards.duplicate()
	
	for i in range(shuffled_cards.size()):
		var zone_index = i % zone_indexes.size()
		zones[zone_indexes[zone_index]]._add_card(shuffled_cards[i])


func position_cards_on_zones() -> Dictionary:
	var card_target_positions := {}
	for zone in zones:
		# Duplicating the array as card.stop_floating has a chance of reparenting a card
		var cards = zone.cards.duplicate()	
		for i in range(cards.size()):
			var card = cards[i]
			var target_pos := Vector2.ZERO
			
			if i == 0:
				target_pos = zone.global_position
			else:
				var prev = cards[i - 1]
				target_pos = prev.neighbor_marker.global_position
			
			card_target_positions.set(card, target_pos)

			var tween = create_tween()
			tween.tween_property(card, "global_position", target_pos, 0.12).set_ease(Tween.EASE_IN)
			SoundManager.play_sound("Card_Collect")
			await tween.finished
			card.stop_floating()
	return card_target_positions
	
func _on_deck_manager_special_card_added(special_card: SpecialCard, character: String):
	var special_zones = zone_manager.specials.get_children()
	for zone in special_zones:
		if Utils.enum_str(Utils.Suit, zone.suit) == character:
			special_card.corresponding_zone = zone
	
func listen_to_normal_card_events() -> void:
	for card in normal_cards:
		card.connect("card_collected", _on_card_collected, CONNECT_ONE_SHOT)
		card.connect("card_settled", _on_card_settled)
		
		for collector in zone_manager.collectors.get_children():
			card.connect("card_is_moving", collector.handle_collector_glow)

func listen_to_special_card_events() -> void:
	for card in special_cards.values(): #This is the change, using the values to get the actual card objects
		card.connect("special_unleashed", _on_special_unleashed, CONNECT_ONE_SHOT)
		
		for zone in zones:
			if zone is NormalZone:
				card.connect("card_is_moving", zone.handle_prohibition_indicator)

func _on_card_collected(card):
	transformation_manager.handle_card_collected(card)
	
	# This is a workaround so that I don't have to implement another signal on card move
	# I want to check if there are any moves left EVEN WHEN a card has been collected
	# If this causes issues, I'll create a separate signal that handles that
	#if state_machine.current_state.has_method("handle_card_settled"):
		#state_machine.current_state.handle_card_settled()
		
	if state_machine.current_state.has_method("handle_card_collected"):
		state_machine.current_state.handle_card_collected()
		
	card.disconnect("card_settled", _on_card_settled)
		
func _on_card_settled(drop_zone):
	drawer.queue_redraw()
	var should_apply_effects = drop_zone and \
		not drop_zone is MetalZone and \
		not drop_zone is CollectorZone
		
	if should_apply_effects:
		transformation_manager.apply_special_card_effects()
	
	if state_machine.current_state.has_method("handle_card_settled"):
		state_machine.current_state.handle_card_settled()

func _on_special_unleashed(suit):
	if state_machine.current_state.has_method("handle_special_unleashed"):
		state_machine.current_state.handle_special_unleashed(suit)
	pass

func _on_collector_clicked(collector):
	if state_machine.current_state.has_method("can_card_be_collected"):
		var can_collect = state_machine.current_state.can_card_be_collected()
		if can_collect.has(collector): # change to while to multiple collect
			can_collect[collector].request_automatic_collection(collector)
			# can_collect = state_machine.current_state.can_card_be_collected() #uncoment to multiple collect
			# await get_tree().create_timer(0.2).timeout # should await for the previos card arrival, othewise the second card would get stuck
