extends Zone
class_name NormalZone

@onready var prohibition_indicator: TextureRect = $Effects/ProhibitionIndicator
@onready var tween: Tween

func _ready():
	super._ready()

func handle_prohibition_indicator(card: Card, turn_on: bool):
	var should_show = card is SpecialCard and turn_on
	toggle_prohibition_indicator(should_show)

func toggle_prohibition_indicator(turn_on: bool) -> void:
	if tween and tween.is_running():
		tween.kill()
	tween = create_tween()

	if turn_on:
		prohibition_indicator.visible = turn_on
		tween.tween_property(prohibition_indicator, "modulate", Color.WHITE, 0.7)
	else:
		await tween.tween_property(prohibition_indicator, "modulate", Color.TRANSPARENT, 0.7).finished
		prohibition_indicator.visible = turn_on

func _can_place(card: Card) -> bool:
	if card is SpecialCard:
		return false

	if cards.is_empty():
		return not card.right_neighbor or is_stack_allowed
	
	if not is_stack_allowed:
		return false
		
	var last_card = cards[-1]
	#print_rich("[b]Last card[/b] on zone is: ", last_card)
	if card is not NormalCard or last_card is not NormalCard:
		return false

	if card.suit == last_card.suit:
		return false
		
	return last_card.number == card.number + 1
