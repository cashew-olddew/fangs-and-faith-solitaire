class_name GamePlayState
extends State

var collected_cards_count = 0
var o: BoardManager = null
func _ready():
	state_machine = get_parent()
	o = owner

func handle_input(_event: InputEvent) -> void:
	pass
	
func update(_delta: float) -> void:
	pass

func enter(_data := {}) -> void:
	o.game_state_changed.emit(name)
	o.input_blocker.set_visible(false)
	handle_card_settled() # This is just looking for an available move


func exit() -> void:
	pass
	
func look_for_available_move():
	# This has auto-collecting side effects. Don't move it from the first spot!!
	var can_be_collected_result = can_card_be_collected()
	if can_be_collected_result != {}:
		#print("Card collected was ok")
		#can_be_collected_result["card"].request_automatic_collection(can_be_collected_result["collector"])
		return true
	if can_special_unleash():
		return true
	if is_empty_zone():
		#print("Empty zone was ok")
		return true
	if is_special_on_metal_zone():
		#print("Special on metal was ok")
		return true
	if is_normal_move_available():
		#print("Normal move was ok")
		return true
	#print("no more moves")
	return false

func is_empty_zone() -> bool:
	var zones: Array = o.zones
	var metal_zones: Array = o.metals
	
	var all_zones = zones.duplicate()
	all_zones.append_array(metal_zones)
	
	for zone in all_zones:
		if zone is Zone:
			if zone.cards.is_empty():
				return true
	return false
	
func can_special_unleash():
	var special_cards = o.special_cards.values()
	for card in special_cards:
		if card._can_move() and not card.is_unleashed:
			return true

func can_card_be_collected():
	var collectors = o.zone_manager.collectors.get_children()
	if collectors.size() < 2:
		return false

	var red_collector = collectors[0] if collectors[0].suit == Utils.Suit.red else collectors[1]
	var black_collector = collectors[1] if red_collector == collectors[0] else collectors[0]

	var next_red = (red_collector.cards.back().number + 1) if red_collector.cards.size() > 0 else 1
	var next_black = (black_collector.cards.back().number + 1) if black_collector.cards.size() > 0 else 1

	var normal_movable_cards := o.normal_cards.filter(func(c): return c is NormalCard and c._can_move())
	red_collector.toggle_glow(false)
	black_collector.toggle_glow(false)

	var to_collect:Dictionary = {}
	for card in normal_movable_cards:
		if card.right_neighbor:
			continue

		if card.suit == Utils.Suit.red and card.number == next_red:
			red_collector.toggle_glow(true)
			to_collect.set(red_collector, card)
		if card.suit == Utils.Suit.black and card.number == next_black:
			black_collector.toggle_glow(true)
			to_collect.set(black_collector, card)

	return to_collect

func is_special_on_metal_zone():
	var metal_zones: Array = o.metals
	
	for zone in metal_zones:
		if zone is MetalZone:
			if zone.cards[0] is SpecialCard:
				return true
	return false
	
func is_normal_move_available():
	var normal_movable_cards := o.normal_cards.filter(func(c): return c is NormalCard and c._can_move())
	var last_cards_on_each_zone := o.zones.map(
		func(zone):
			return zone.cards.back() if zone is Zone and zone.cards.size() > 0 else null
	)
	
	for card in normal_movable_cards:
		for target in last_cards_on_each_zone:
			var valid_target = target is NormalCard \
				and target.suit != card.suit \
				and target.number == card.number + 1
			if valid_target:
				#print("Because ", card.number, '-', card.suit, " is smaller than ", target.number, '-', target.suit)
				return true
	return false

func handle_card_settled():
	var is_available_move_found = look_for_available_move()
	if not is_available_move_found:
		await trigger_game_over()
		return
	for card in owner.special_cards.values():
		card.request_unleash()

func handle_card_collected():

	collected_cards_count += 1
	
	if collected_cards_count == owner.normal_cards.size():
		# Turn off collector glows when winning
		var collectors = o.zone_manager.collectors.get_children()
		for collector in collectors:
			collector.toggle_glow(false)
			
		owner.animation_manager.allow_unleash = false
		state_machine.change_state("GameWon")
		return
		
	var is_available_move_found = look_for_available_move()
	if not is_available_move_found:
		await trigger_game_over()
		return
		
	for card in owner.special_cards.values():
		card.request_unleash()

func handle_special_unleashed(suit):
	# This is also neede here because if a special card covers a normal card then the collectors won't light up
	var is_available_move_found = look_for_available_move()
	if not is_available_move_found:
		await trigger_game_over()
		return
	for card in owner.special_cards.values():
		if card.suit != suit:
			card.request_unleash()

func trigger_game_over():
	owner.animation_manager.allow_unleash = false

	# Wait for animations to complete with 5-second timeout
	var max_wait_time = 5.0
	var elapsed_time = 0.0

	while owner.animation_manager.are_unleash_animations_running() and elapsed_time < max_wait_time:
		await get_tree().process_frame
		elapsed_time += get_process_delta_time()

	state_machine.change_state("GameOver")
