extends Holder
class_name Card

const DRAGGING_SPEED = 50
const BACKGROUND_DIR = "res://assets/cards/"
const CHARACTER_DIR = "res://assets/faces/"

@export_category("Textures")
@export var back_texture: Texture2D = null
@export var face_texture: Texture2D = null

@export var suit: Utils.Suit = Utils.Suit.black

@onready var images = $Images
@onready var back: TextureRect = $Images/Back
@onready var face: TextureRect = $Images/Face
@onready var zone_collision = $ZoneCollision
@onready var neighbor_marker = $NeighborMarker
@onready var drag_area = $DragArea

@onready var state_machine: StateMachine = $StateMachine

var current_placement = Vector2.ZERO

var left_neighbor: Card = null
var right_neighbor: Card = null

var can_place_callable: Callable = func(card): pass

signal card_is_moving(card: Card, in_hand: bool)
signal card_is_released(card: Card)
signal neighbor_added(card: Card)

func _ready() -> void:
	paint()

func _process(delta: float) -> void:
	state_machine.update(delta)
	queue_redraw()

func paint() -> void:
	back.texture = back_texture
	face.texture = face_texture
	
func start_floating() -> void:
	var floating_z_index = 1000
	z_index = floating_z_index
	zone_collision.disabled = true
	
	var neighbor = right_neighbor
	while neighbor:
		floating_z_index += 1
		neighbor.z_index = floating_z_index
		neighbor.zone_collision.disabled = true
		neighbor.reparent(self)
		neighbor = neighbor.right_neighbor
		
func stop_floating() -> void:
	var grounded_z_index = 0
	if left_neighbor:
		grounded_z_index = left_neighbor.z_index + 1
	z_index = grounded_z_index
	if not right_neighbor:
		zone_collision.disabled = false

	var neighbor = right_neighbor
	while neighbor:
		grounded_z_index += 1
		neighbor.z_index = grounded_z_index
		neighbor.reparent(self.get_parent())

		if not neighbor.right_neighbor:
			neighbor.zone_collision.disabled = false
		
		neighbor = neighbor.right_neighbor

func get_opposite_suit() -> Utils.Suit:
	return Utils.Suit.red if suit == Utils.Suit.black else Utils.Suit.black

func _on_drag_area_input_event(viewport, event, shape_idx):
	state_machine.handle_input(event)

# This is here due to the card following - the cursor position if you move the card too fast it won't recive the release input thus this function
func _input(event):
	if event.is_action_released("click"):
		state_machine.handle_input(event)
	pass

func _can_move() -> bool:
# to be implemented in child class
	return false
	
func _get_snapping_point() -> Vector2:
	return neighbor_marker.global_position
	
func _add_card(card: Card) -> void:
	neighbor_added.emit(card)
	
func _can_place(card: Card) -> bool:
	return can_place_callable.call(card)
