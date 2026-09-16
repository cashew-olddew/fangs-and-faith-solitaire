extends Control

@onready var canvas_layer: CanvasLayer = $CanvasLayer
@onready var blur_container: PanelContainer = $CanvasLayer/BlurContainer
@onready var game_over: VBoxContainer = $CanvasLayer/GameOver

@onready var menus := {
	UI.MenuType.MAIN_MENU: $CanvasLayer/BlurContainer/MarginSettings/VBoxMainMenu,
	UI.MenuType.SETTINGS: $CanvasLayer/BlurContainer/MarginSettings/VBoxSettings,
	UI.MenuType.RULES: $CanvasLayer/BlurContainer/MarginTutorial,
	UI.MenuType.GAMEOVER: $CanvasLayer/GameOver
}

signal quit_game

var is_paused: bool = false
var current_state = UI.MenuType.MAIN_MENU

const GAME_OVER_TIMER = 1

func _ready() -> void:
	canvas_layer.visible = false
	menus[UI.MenuType.RULES].connect("quit", _on_quit_pressed)
	
	var first_time: bool = SaveManager.settings_config.get_value("FIRST", "TUTORIAL", true)
	if first_time:
		show_tutorial()
		SaveManager.settings_config.set_value("FIRST", "TUTORIAL", false)
		SaveManager.save_settings()
		
func _input(event: InputEvent) -> void:
	if current_state == UI.MenuType.GAMEOVER:
		return
	if event.is_action_pressed("pause_game"):
		swap_paused_game_state(not is_paused)
		SoundManager.play_ui_sound("Esc")
	
func _on_quit_pressed():
	swap_paused_game_state(false)

func _on_button_exit_to_menu_pressed() -> void:
	#connected also to the root script's exit to menu function
	swap_paused_game_state(false)
	exit_to_menu()

func _on_button_resume_game_pressed() -> void:
	swap_paused_game_state(false)
	
func select_current_menu(menu: UI.MenuType) -> void:
	for view in menus.values():
		view.visible = false
	
	if menus.has(menu):
		menus[menu].visible = true
		current_state = menu
	else:
		#print("Provided menu type ", menu, " does not exist")
		pass
		
func swap_paused_game_state(new_state: bool, real_pause = true) -> void:
	canvas_layer.visible = new_state
	if real_pause:
		get_tree().paused = new_state
		is_paused = new_state
	else:
		get_tree().paused = false
	#blur_container.visible = not blur_container.visible
	select_current_menu(UI.MenuType.MAIN_MENU)

func _on_button_settings_pressed() -> void:
	select_current_menu(UI.MenuType.SETTINGS)

func _on_back_button_pressed() -> void:
	select_current_menu(UI.MenuType.MAIN_MENU)
	
func _on_button_game_rules_pressed() -> void:
	select_current_menu(UI.MenuType.RULES)
	
func _on_board_manager_game_state_changed(state: String) -> void:
	var game_over_text = ""
	var game_end_sound = ""
	
	if state == "GameWon":
		game_over_text = "[win amp=12 freq=4 off=.9]{win}[/win]".format({win = tr("YOU_WON")})
		game_end_sound = "Victory"
	if state == "GameOver":
		game_over_text = "[loss amp=12 freq=4 off=.9]{loss}[/loss]".format({loss = tr("GAME_OVER")})
		game_over.particles.visible = false
		game_end_sound = "Defeat"
		
	if game_over_text != "":
		await get_tree().create_timer(GAME_OVER_TIMER).timeout
		game_over.update_text(game_over_text)
		game_over.fade_out()
		
		SoundManager.play_sound(game_end_sound, false)
		
		blur_container.visible = false
		swap_paused_game_state(true, false)
		select_current_menu(UI.MenuType.GAMEOVER)

func show_tutorial() -> void:
	swap_paused_game_state(true)
	select_current_menu(UI.MenuType.RULES)
	
func exit_to_menu() -> void:
	for child in canvas_layer.get_children():
		child.visible = false
	var loading_scene = UI.LOADING_SCREEN.instantiate()
	loading_scene.next_scene = "res://scenes/ui/main_menu.tscn"
	# Add Loading screen to the canvas layer
	canvas_layer.add_child(loading_scene)

func _on_button_exit_pressed() -> void:
	quit_game.emit()

func _on_reset_button_pressed() -> void:
	SteamManager.set_statistic("nr_consecutive_wins", 0)
	get_tree().reload_current_scene()

func _on_game_over_back_button_pressed() -> void:
	exit_to_menu()

func _on_game_over_play_again_button_pressed() -> void:
	get_tree().reload_current_scene()

func _on_pause_button_pressed() -> void:
	swap_paused_game_state(true)
