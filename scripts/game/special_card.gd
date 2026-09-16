extends Card
class_name SpecialCard

const PARTICLES_DIR = "res://scenes/game"
const SCENE = preload("res://scenes/game/special_card.tscn")
var corresponding_zone: SpecialZone = null
var unleash_type = "simple"
var is_unleashed: bool = false

# This doesn't align with how normal card particles work. It adds some code redundancy,
# but it works this way. Currently there's no need to change this.
var particles_scene: Resource = null 

var marked_card: NormalCard = null
var turn_counter: int = 0
var transform_frequency: int = 0

signal special_unleashed

var special_effect_sounds: Dictionary = {
	Utils.Suit.red: {
		"transform": "Vampire_Bite",
		"unleash": "Vampire_Uncover"
	},
	Utils.Suit.black: {
		"transform": "Priest_Heal",
		"unleash": "Priest_Uncover"
	}
}
	
@onready var animation = $Animation

signal card_activated(card: SpecialCard)
signal card_deactivated(card: SpecialCard)
signal unleashed
signal looking_for_target

static func get_instance(suit: String) -> SpecialCard:
	var bg_name = "blank_{0}_small".format([suit])
	var character = "special_{0}".format([suit])
	var particles = "{0}_particles".format([suit])
	
	var card: SpecialCard = SCENE.instantiate()
	
	card.back_texture = load(Utils.full_path(BACKGROUND_DIR, bg_name))
	card.face_texture = load(Utils.full_path(CHARACTER_DIR, character))
	
	card.suit = Utils.Suit[suit]
	card.particles_scene = load(Utils.full_path(PARTICLES_DIR, particles, ".tscn"))
	
	return card

func _can_move() -> bool:
	if not right_neighbor:
		return true
	
	return false
	
func is_active() -> bool:
	return state_machine.current_state is ActiveState

func mark_normal_card(card: NormalCard) -> void:
	marked_card = card
	if is_active():
		toggle_marked_card_particles(true)

func toggle_marked_card_particles(toggle: bool):
	if marked_card:
		marked_card.toggle_particles(toggle)

func effects_are_paused() -> bool:
	if transform_frequency == 0:
		return false
	return turn_counter % transform_frequency != 0
	
func apply_special_card_effects() -> void:
	if not is_active():
		return
	if not marked_card:
		looking_for_target.emit()
		return
	turn_counter += 1
	if effects_are_paused():
		return
	await transform_normal_card()

func transform_normal_card() -> void:
	SoundManager.play_sound(special_effect_sounds[suit]["transform"])
	StatsManager.increase_by_suit(suit)
	
	marked_card.toggle_particles(false)
	marked_card.burst_particles()
	marked_card.change_suit()
	marked_card = null
	looking_for_target.emit()
	
func free_normal_card() -> void:
	marked_card.toggle_particles(false)
	marked_card = null
	looking_for_target.emit()

func request_unleash() -> void:
	if not is_unleashed and not right_neighbor:
		emit_signal("card_is_released", self)
		corresponding_zone._add_card(self)
		state_machine.change_state("Unleashed")
		emit_signal("special_unleashed", self.suit) # moved this after the state change so the game won't crash when both cards unleash simultaniously
