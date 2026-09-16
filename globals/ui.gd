extends Node

signal cursor_setting_changed(using_system_cursor: bool)

const LOADING_SCREEN = preload("res://scenes/ui/loading_screen.tscn")
enum MenuType { MAIN_MENU, SETTINGS, CREDITS, RULES, GAMEOVER, DIFFICULTY }
