extends Card
class_name NormalCard

@export var number: int = 0
@export var character: Utils.Characters = Utils.Characters.man
var suit_texture: Texture2D = null
var finished_collected_animation = false # Exception since the collection happens on state enter

@onready var number_left = $Images/MarginNumberSuit/NumberSuit/Left/Number
@onready var number_right = $Images/MarginNumberSuit/NumberSuit/Control/Right/Number

@onready var suit_left = $Images/MarginNumberSuit/NumberSuit/Left/Suit
@onready var suit_right = $Images/MarginNumberSuit/NumberSuit/Control/Right/Suit

@onready var particles_group = $Particles
@onready var overlayed_particles: Node2D = $OverlayedParticles

const SCENE: PackedScene = preload("res://scenes/game/normal_card.tscn")

@onready var state_label: Label = $Label

var is_neutralized: bool = false

signal card_collected(card: NormalCard)
signal card_settled(drop_zone)

static func get_instance(number: int, suit: String) -> NormalCard:
	var card: NormalCard = SCENE.instantiate()
	card.number = number
	card.character = Utils.Characters.woman if number % 2 == 0 else Utils.Characters.man
	card.set_suit_related_properties(suit)

	return card

func _ready() -> void:
	super._ready()
	number_left.text = str(number)
	number_right.text = str(number)

func set_suit_related_properties(new_suit: String) -> void:
	var bg_name = "blank_{0}_small".format([new_suit])

	var ch_name = str(Utils.enum_str(Utils.Characters, character), "_", new_suit)
	var suit_name = "suit_{0}".format([new_suit])
	
	back_texture = load(Utils.full_path(BACKGROUND_DIR, bg_name))
	face_texture = load(Utils.full_path(CHARACTER_DIR, ch_name))
	suit_texture = load(Utils.full_path(BACKGROUND_DIR, suit_name))
	
	suit = Utils.Suit[new_suit]

func paint() -> void:
	super.paint()
	var number_color = Color.from_string("a50000", Color.BLUE) if suit == Utils.Suit.red else Color.BLACK
	number_left.add_theme_color_override("font_color", number_color)
	number_right.add_theme_color_override("font_color", number_color)
	
	suit_left.texture = suit_texture
	suit_right.texture = suit_texture
	
func change_suit() -> void:
	var opposite_suit = Utils.enum_str(Utils.Suit, get_opposite_suit())
	set_suit_related_properties(opposite_suit)
	paint()

func _can_move() -> bool:
	# Check that all left neighbors are in IDLE
	var current = self
	while current:
		if current is Card and current.state_machine.current_state.name != "Idle":
			return false
		current = current.left_neighbor
		
	if not right_neighbor and not is_collected():
		return true
	
	var valid_neighbor = right_neighbor is NormalCard \
		and right_neighbor.suit != suit and right_neighbor.number == number - 1
	
	if not valid_neighbor:
		return false
	
	return right_neighbor._can_move()

func is_collected() -> bool:
	return state_machine.current_state is CollectedState

func get_particles_name(particles_suit: Utils.Suit) -> String:
	return Utils.capitalize_first_letter(Utils.enum_str(Utils.Suit, particles_suit)) + "Particles"

func toggle_particles(emit: bool) -> void:
	particles_group.toggle_emit(get_opposite_suit(), emit)

func burst_particles() -> void:
	var particles = overlayed_particles.burst(get_opposite_suit())
	
func request_automatic_collection(collector: CollectorZone):
	if collector.cards.is_empty() or collector.cards[-1].finished_collected_animation:
		emit_signal("card_is_released", self)
		collector._add_card(self)
		state_machine.call_deferred("change_state", "Collected", { "drop_area": collector })
