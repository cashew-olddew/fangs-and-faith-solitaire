extends Zone
class_name MetalZone

func _can_place(card: Card) -> bool:
	if cards.is_empty():
		return not card.right_neighbor or is_stack_allowed
	
	if not is_stack_allowed:
		return false
		
	var last_card = cards[-1] 
	
	if card is not NormalCard or last_card is not NormalCard:
		return false

	if card.suit == last_card.suit:
		return false
		
	return last_card.number == card.number + 1
