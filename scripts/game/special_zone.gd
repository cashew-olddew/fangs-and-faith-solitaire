extends Zone
class_name SpecialZone

@export var suit: Utils.Suit = Utils.Suit.black

func _can_place(card: Card):
	if card is not SpecialCard:
		return false
	
	if card.right_neighbor:
		return false
	
	return suit == card.suit
