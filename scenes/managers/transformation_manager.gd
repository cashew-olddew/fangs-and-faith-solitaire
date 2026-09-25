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
		special_card.mark_normal_card(pick_fair_target(transformable_cards))
	# TODO: else animate the special card to show that there are no other cards to transform

# Priority: unordered & safe > safe in the smallest ordered run > leads to game over
func pick_fair_target(candidates: Array) -> NormalCard:
	var run_sizes := get_ordered_run_sizes()
	var safe_cards := candidates.filter(func(card): return not would_cause_game_over(card))
	if safe_cards.is_empty():
		return candidates.pick_random()

	var unordered_cards := safe_cards.filter(func(card): return not run_sizes.has(card))
	if not unordered_cards.is_empty():
		return unordered_cards.pick_random()

	var smallest_run: int = safe_cards.map(func(card): return run_sizes[card]).min()
	return safe_cards.filter(func(card): return run_sizes[card] == smallest_run).pick_random()

func get_all_zones() -> Array:
	var board: BoardManager = owner
	return board.zones + board.metals

func is_ordered_pair(upper: Card, lower: Card) -> bool:
	return upper is NormalCard and lower is NormalCard \
		and upper.suit != lower.suit and upper.number == lower.number + 1

# Maps every card that belongs to an ordered run (2+ cards) to that run's length
func get_ordered_run_sizes() -> Dictionary:
	var run_sizes := {}
	for zone: Zone in get_all_zones():
		var run: Array = []
		for card in zone.cards:
			if not run.is_empty() and is_ordered_pair(run[-1], card):
				run.append(card)
				continue
			register_run(run, run_sizes)
			run = [card] if card is NormalCard else []
		register_run(run, run_sizes)
	return run_sizes

func register_run(run: Array, run_sizes: Dictionary) -> void:
	if run.size() < 2:
		return
	for card in run:
		run_sizes[card] = run.size()

func would_cause_game_over(card: NormalCard) -> bool:
	var original_suit := card.suit
	card.suit = card.get_opposite_suit()
	var has_move := has_available_move()
	card.suit = original_suit
	return not has_move

# Side-effect free mirror of GamePlayState.look_for_available_move
func has_available_move() -> bool:
	var board: BoardManager = owner
	var all_zones := get_all_zones()

	for zone: Zone in all_zones:
		if zone.cards.is_empty():
			return true
		if zone is MetalZone and zone.cards[0] is SpecialCard:
			return true

	for special_card: SpecialCard in special_cards.values():
		if special_card._can_move() and not special_card.is_unleashed:
			return true

	var next_numbers := {}
	for collector: CollectorZone in board.zone_manager.collectors.get_children():
		next_numbers[collector.suit] = collector.cards.back().number + 1 if not collector.cards.is_empty() else 1

	var targets := board.zones.map(func(zone): return zone.cards.back() if not zone.cards.is_empty() else null)

	for zone: Zone in all_zones:
		for card: NormalCard in get_movable_cards(zone):
			if not card.right_neighbor and next_numbers.get(card.suit, 0) == card.number:
				return true
			for target in targets:
				if is_ordered_pair(target, card):
					return true
	return false

# The trailing ordered run of a zone, i.e. the cards that can be picked up
func get_movable_cards(zone: Zone) -> Array:
	var movable: Array = []
	for i in range(zone.cards.size() - 1, -1, -1):
		var card: Card = zone.cards[i]
		if card is not NormalCard:
			break
		if not movable.is_empty() and not is_ordered_pair(card, movable[-1]):
			break
		movable.append(card)
	return movable
