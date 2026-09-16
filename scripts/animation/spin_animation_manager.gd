extends Node
class_name SpinManager

@onready var card_rotation_pivot = $CardRotationPivot

@export_category("Card Settings")
@export var circle_radius: float = 360
@export_range(0.0, 1.0, 0.1) var rotation_speed: float = 1.0

var cards_to_spin: Array = []
var special_cards: Array = []

var tweens_done = 0

func _ready():
	var viewport_size = get_viewport().get_visible_rect().size
	card_rotation_pivot.global_position = viewport_size / 2
	
func _process(delta):
	if tweens_done >= cards_to_spin.size():
		card_rotation_pivot.rotate(delta * rotation_speed)
	
func animate():
	order_cards_z_index(1)
	const base_duration: float = 0.025
	
	var card_count: float = cards_to_spin.size()
	var space_between_cards: float = 360.0 / card_count
	
	for index in range(0, card_count):
		var card = cards_to_spin[index]
		
		var current_rotation: float = (index + 1) * space_between_cards
		var animation_duration: float = base_duration * (index + 1)
		
		card.reparent(card_rotation_pivot)
		rotate_card_by_degrees(card, current_rotation, animation_duration)
		
	SoundManager.play_sound("Card_Collect")
	if special_cards.size() > 0:
		float_special_card(special_cards[0], card_rotation_pivot.global_position + Vector2(0, -circle_radius / 2))
		float_special_card(special_cards[1], card_rotation_pivot.global_position + Vector2(0, circle_radius / 2))


func float_special_card(card, position):
	var move_tween = get_tree().create_tween()
	move_tween.tween_property(card, "global_position", position, 0.75) \
		.set_delay(randf() / 10) \
		.set_ease(Tween.EASE_IN_OUT) \
		.set_trans(Tween.TRANS_QUART)
	await move_tween.finished
	
	var float_tween = get_tree().create_tween()
	float_tween.bind_node(card)
	float_tween.tween_property(card, "scale", Vector2(1.2, 1.2), 0.5)
	float_tween.tween_property(card, "scale", Vector2(1.0, 1.0), 0.5)
	float_tween.set_loops()

func rotate_card_by_degrees(card: NormalCard, rotation_deg: float, rotation_duration: float):
	var new_position = Vector2(0, -circle_radius)
	
	var tween = get_tree().create_tween()
	tween.set_ease(Tween.EASE_IN_OUT)
	# It's okay to kinda destroy the card structure because I won't be using it anyway afterwards
	tween.set_parallel(true)
	tween.tween_property(card.images, "position", card.images.position + new_position, 1).set_trans(Tween.TRANS_CUBIC)
	tween.tween_property(card, "global_position", card_rotation_pivot.global_position, 0.75).set_ease(Tween.EASE_OUT).set_trans(Tween.TRANS_EXPO)
	
	tween.set_parallel(false)
	tween.tween_property(card, "rotation_degrees", rotation_deg, rotation_duration)
	tween.tween_callback(_card_done)

func _card_done():
	tweens_done += 1
	
func order_cards_z_index(starting_z_index: int) -> void:
	# Cards should be reordered first so that they are in increasing, alternating order
	cards_to_spin.sort_custom(
		func(c1, c2):
			if c1.number != c2.number:
				return c1.number < c2.number
			return c1.suit == Utils.Suit.black
	)
	
	for index in cards_to_spin.size():
		var card = cards_to_spin[index]
		card.z_index = starting_z_index + index
