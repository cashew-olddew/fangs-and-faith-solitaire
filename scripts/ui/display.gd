extends VBoxContainer

@onready var check_box_full_screen: CheckBox = $HBoxFullScreen/CheckBoxFullScreen
@onready var option_button_resolution: OptionButton = $HBoxScreenResolution/OptionButtonResolution

var window_mode: int
var resolution: Vector2i

var resolutions: Dictionary = {
	"3840x2160":Vector2i(3840,2160),
	"2560x1600":Vector2i(2560, 1600),
	"2560x1440":Vector2i(2560,1440),
	"1920x1200":Vector2i(1920,1200),
	"1920x1080":Vector2i(1920,1080),
	"1680x1050":Vector2i(1680,1050),
	"1600x900":Vector2i(1600,900),
	"1536x864":Vector2i(1536,864),
	"1440x900":Vector2i(1440,900),
	"1366x768":Vector2i(1366,768),
	"1280x800":Vector2i(1280,800),
	"1280x720":Vector2i(1280,720),
	"1024x600":Vector2i(1024,600),
}

var fulscreen_mode = DisplayServer.WINDOW_MODE_FULLSCREEN

func _ready() -> void:
	if Steam.isSteamRunningOnSteamDeck():
		# Really dumb but it works
		# If display is set on fulscreen on steamdeck it appears smaller
		# and it only fixes it by uncheching the fullscreen putting a higher resolution and then going
		# back into fullscreen mode
		fulscreen_mode = DisplayServer.WINDOW_MODE_EXCLUSIVE_FULLSCREEN
		DisplayServer.window_set_mode(DisplayServer.WINDOW_MODE_WINDOWED)
		_update_resolution(Vector2i(3840,2160))
		check_box_full_screen.disabled = true
	set_popup_menu_background()
	add_resolutions_to_option_button()
	load_full_screen_settings()
	
func set_popup_menu_background() -> void:
	var popup_menu: PopupMenu = option_button_resolution.get_popup()
	popup_menu.transparent_bg = PopupMenu.FLAG_TRANSPARENT
	
func add_resolutions_to_option_button() -> void:
	var display_size: Vector2i = DisplayServer.screen_get_size()
	var saved_resolution: Vector2i = SaveManager.get_value(
		"GRAPHICS", "RESOLUTION", display_size
	)

	for res in resolutions:
		option_button_resolution.add_item(res)
		if saved_resolution == resolutions[res]:
			var index: int = option_button_resolution.item_count - 1
			option_button_resolution.select(index) 
			_update_resolution(saved_resolution)

func center_window() -> void:
	var screen_center: Vector2i = DisplayServer.screen_get_position() + DisplayServer.screen_get_size()/2
	var window_size: Vector2i = DisplayServer.window_get_size_with_decorations()
	DisplayServer.window_set_position(screen_center-window_size/2)
	
func load_full_screen_settings() -> void:
	var screen_mode: int = SaveManager.get_value(
		"GRAPHICS", "WINDOW", fulscreen_mode
	)

	check_box_full_screen.button_pressed = (screen_mode == fulscreen_mode)
	DisplayServer.window_set_mode(screen_mode)
	
func _on_check_box_full_screen_toggled(toggled_on: bool) -> void:
	option_button_resolution.disabled = toggled_on
	
	if toggled_on:
		window_mode = fulscreen_mode
	else:
		window_mode = DisplayServer.WINDOW_MODE_WINDOWED
	
	SaveManager.set_value("GRAPHICS", "WINDOW", window_mode)
	DisplayServer.window_set_mode(window_mode)


func _on_option_button_resolution_item_selected(index: int) -> void:
	resolution = resolutions.get(option_button_resolution.get_item_text(index))
	_update_resolution(resolution)
	
	SaveManager.set_value("GRAPHICS", "RESOLUTION", resolution)
	
func _update_resolution(res: Vector2i) -> void:
	DisplayServer.window_set_size(res)
	center_window()
