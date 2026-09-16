extends Node

enum CategoryType { DISPLAY, AUDIO, USER_INTERFACE, PARENT_CATEGORY}

@onready var categories := {
	CategoryType.DISPLAY: $VBoxDisplay,
	CategoryType.AUDIO: $VBoxAudio,
	CategoryType.USER_INTERFACE: $VBoxUserInterface,
	CategoryType.PARENT_CATEGORY: $VBoxCategories
}

@onready var button_back_to_categories: Button = $ButtonBackToCategories

signal button_back_pressed

func show_category(type: CategoryType = CategoryType.PARENT_CATEGORY) -> void:
	for category in categories.values():
		category.visible = false
	button_back_to_categories.visible = false
	
	if categories.has(type):
		categories[type].visible = true
		if type != CategoryType.PARENT_CATEGORY:
			button_back_to_categories.visible = true
	else:
		#print("There is no category of type ", type)
		pass

func _ready() -> void:
	show_category(CategoryType.PARENT_CATEGORY)

func _on_video_pressed() -> void:
	show_category(CategoryType.DISPLAY)

func _on_audio_pressed() -> void:
	show_category(CategoryType.AUDIO)

func _on_user_interface_pressed() -> void:
	show_category(CategoryType.USER_INTERFACE)

func _on_button_back_to_categories_pressed() -> void:
	show_category(CategoryType.PARENT_CATEGORY)

func _on_button_back_to_menu_pressed() -> void:
	show_category(CategoryType.PARENT_CATEGORY)
	button_back_pressed.emit()
