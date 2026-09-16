extends Node

var transformed_by_priest = 0
var transformed_by_vampire = 0

func _ready():
	clear_stats()
	
func increase_by_suit(suit: Utils.Suit):
	if suit == Utils.Suit.red:
		transformed_by_vampire += 1
	if suit == Utils.Suit.black:
		transformed_by_priest += 1

func clear_stats():
	transformed_by_priest = 0
	transformed_by_vampire = 0
