extends HBoxContainer

class_name LabeledDropDown

@export var label_text: String = ''
@export_category("Options Drop Down")
@export var options: Dictionary = {}
@export var default_option: String = ''
@export var save_file_settings: Dictionary = {
	"group": "",
	"property": ""
}

@onready var label: Label = $Label
@onready var option_button: Button = $OptionButton

func _ready() -> void:
	label.text = label_text
	set_popup_menu_background()
	setup_options_dictionary()
	load_saved_option()

func set_popup_menu_background() -> void:
	var popup_menu: PopupMenu = option_button.get_popup()
	popup_menu.transparent_bg = PopupMenu.FLAG_TRANSPARENT

func get_saved_option() -> String:
	return SaveManager.get_value(
		save_file_settings.group,
		save_file_settings.property,
		default_option
	)

func setup_options_dictionary() -> void:
	var saved_option: String = get_saved_option()

	for option: String in options:
		option_button.add_item(options[option])
		if saved_option == option:
			option_button.select(option_button.item_count - 1)

func apply_option_changes(_option: String) -> void:
	# To be implemented by child class 
	pass
	
func load_saved_option() -> void:
	var saved_option: String = get_saved_option()
	apply_option_changes(saved_option)

func _on_option_button_item_selected(index: int) -> void:
	var option: String = options.find_key(option_button.get_item_text(index))
	var can_save = save_file_settings.group and save_file_settings.property
	if can_save:
		SaveManager.set_value(
			save_file_settings.group,
			save_file_settings.property,
			option
		)
		apply_option_changes(option)
	else:
		#printerr("Unable to save current language. Did you set the \"Save File Settings\" property?")
		pass
