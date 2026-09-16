extends HBoxContainer
@onready var check_box_cursor: CheckBox = $CheckBoxCursor

var cursor: Resource = preload("res://assets/ui/cursors/default.png")
var cursor_vampire_hand: Resource = preload("res://assets/ui/cursors/point_vampire.png")
var cursor_priest_hand: Resource = preload("res://assets/ui/cursors/point_priest.png")

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	var using_system_cursor: bool = SaveManager.get_value("GRAPHICS", "SYSTEM_CURSOR", false)
	check_box_cursor.button_pressed = using_system_cursor

	_update_cursor(using_system_cursor)

func _on_check_box_cursor_toggled(toggled_on: bool) -> void:
	_update_cursor(toggled_on)
	SaveManager.set_value("GRAPHICS", "SYSTEM_CURSOR", toggled_on)
	UI.cursor_setting_changed.emit(toggled_on)
	
func _update_cursor(using_system_cursor: bool):
	var icon = null
	var icon_priest_hand = null
	var icon_vampire_hand = null
	if not using_system_cursor:
		icon = cursor
		icon_priest_hand = cursor_priest_hand
		icon_vampire_hand = cursor_vampire_hand
	Input.set_custom_mouse_cursor(icon_priest_hand, Input.CURSOR_POINTING_HAND)
	Input.set_custom_mouse_cursor(icon_vampire_hand, Input.CURSOR_CAN_DROP)
	Input.set_custom_mouse_cursor(icon)
