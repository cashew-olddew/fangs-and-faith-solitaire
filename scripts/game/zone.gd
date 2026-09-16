extends Holder
class_name Zone

@export var texture: Texture2D = null
@export var is_stack_allowed: bool = true

@onready var sprite_2d := $Sprite2D
@onready var collision_shape_2d: CollisionShape2D = $CollisionShape2D

var cards: Array[Card] = []

func _ready():
	sprite_2d.texture = texture
	
func _can_place(_card: Card):
	# To be implemented by inheriting classes
	return false
	
func _get_snapping_point() -> Vector2:
	return global_position
	
func _add_card(card: Card):
	if cards.is_empty():
		collision_shape_2d.disabled = true
	else:
		cards[-1].right_neighbor = card
		cards[-1].zone_collision.disabled = true
		card.left_neighbor = cards[-1]
		
	var card_to_add = card
	
	while card_to_add:
		card_to_add.can_place_callable = _can_place
		cards.append(card_to_add)
		connect_card_signals(card_to_add)
		card_to_add = card_to_add.right_neighbor

func connect_card_signals(card: Card) -> void:
	card.connect("card_is_released", _remove_card)
	card.connect("neighbor_added", _add_card)
	
func disconnect_card_signals(card: Card) -> void:
	card.disconnect("card_is_released", _remove_card)
	card.disconnect("neighbor_added", _add_card)

func _remove_card(card: Card):
	if card not in cards:
		return
		
	var card_to_remove = card
	if card_to_remove.left_neighbor:
		card_to_remove.left_neighbor.zone_collision.disabled = false
		card_to_remove.left_neighbor.right_neighbor = null
		card_to_remove.left_neighbor = null
	else:
		collision_shape_2d.disabled = false

	while card_to_remove:
		disconnect_card_signals(card_to_remove)
		cards.erase(card_to_remove)
		card_to_remove = card_to_remove.right_neighbor

func add_cards(new_cards: Array):
	for card in new_cards:
		_add_card(card)
		
