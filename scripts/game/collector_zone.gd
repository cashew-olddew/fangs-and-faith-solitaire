extends Zone
class_name CollectorZone

@export var suit: Utils.Suit = Utils.Suit.black
@onready var glow: ColorRect = $Effects/Glow
@onready var tween: Tween
@onready var input_picker: ColorRect = $InputPicker

signal collector_clicked(collector)

func _ready():
	super._ready()
	var glow_material: ShaderMaterial = glow.material.duplicate()
	
	if suit == Utils.Suit.black:
		glow_material.set_shader_parameter("glow_color", Color.YELLOW)
	else:
		glow_material.set_shader_parameter("glow_color", Color.RED)
	glow.material = glow_material;
	
	UI.cursor_setting_changed.connect(_on_cursor_setting_changed)

func get_cursor_type() -> Control.CursorShape:
	var using_system_cursor: bool = SaveManager.get_value("GRAPHICS", "SYSTEM_CURSOR", false)
	if not using_system_cursor and suit == Utils.Suit.red:
			return Control.CURSOR_CAN_DROP
	return Control.CURSOR_POINTING_HAND

func handle_collector_glow(card: Card, turn_on: bool):
	toggle_glow(_can_place(card) and turn_on)

func _on_cursor_setting_changed(_using_system_cursor: bool):
	if glow.visible:
		input_picker.mouse_default_cursor_shape = get_cursor_type()

func toggle_glow(turn_on: bool) -> void:
	if tween and tween.is_running():
		tween.kill()
	tween = create_tween()

	if turn_on:
		glow.visible = turn_on
		input_picker.mouse_default_cursor_shape = get_cursor_type()
		tween.tween_property(glow, "color", Color.WHITE, .5)
	else:
		input_picker.mouse_default_cursor_shape = Control.CURSOR_ARROW
		await tween.tween_property(glow, "color", Color.TRANSPARENT, .5).finished
		glow.visible = turn_on

func _can_place(card: Card) -> bool:
	if card is SpecialCard:
		return false

	if card.suit != suit:
		return false
	
	if cards.is_empty():
		return card.number == 1 and not card.right_neighbor
	
	var last_card = cards[-1]
	return last_card.number == card.number - 1 and not card.right_neighbor

#InputPicker node, it picks the input because the colider of the colector is not the top most in the tree so it won't pick input otherwise
func _on_color_rect_gui_input(event: InputEvent) -> void:
	if event.is_action_pressed("click"):
		collector_clicked.emit(self)
