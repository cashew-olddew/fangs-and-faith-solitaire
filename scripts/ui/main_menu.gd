extends Node

@onready var menus := {
	UI.MenuType.MAIN_MENU: $VBoxMainMenu,
	UI.MenuType.SETTINGS: $VBoxSettings,
	UI.MenuType.CREDITS: $PanelCredits,
	UI.MenuType.DIFFICULTY: $VBoxDifficulty
}

func select_current_menu(menu: UI.MenuType) -> void:
	for view in menus.values():
		view.visible = false
	
	if menus.has(menu):
		menus[menu].visible = true
	else:
		#print("Provided menu type ", menu, " does not exist")
		pass

func _ready() -> void:
	select_current_menu(UI.MenuType.MAIN_MENU)
	var os_language = SaveManager.get_value("INTERNATIONALIZATION", "LANGUAGE", "en")
	TranslationServer.set_locale(os_language)
	
func _on_button_new_game_pressed() -> void:
	select_current_menu(UI.MenuType.DIFFICULTY)

func _on_button_settings_pressed() -> void:
	select_current_menu(UI.MenuType.SETTINGS)

func _on_button_credits_pressed() -> void:
	select_current_menu(UI.MenuType.CREDITS)

func _on_button_exit_pressed() -> void:
	get_tree().quit()
	
func _on_button_back_pressed() -> void:
	select_current_menu(UI.MenuType.MAIN_MENU)

func _on_v_box_settings_button_back_pressed() -> void:
	select_current_menu(UI.MenuType.MAIN_MENU)

func _on_button_difficulty_start_game_pressed() -> void:
	var loading_scene = UI.LOADING_SCREEN.instantiate()
	loading_scene.next_scene = "res://scenes/game/game.tscn"
	add_child(loading_scene)
