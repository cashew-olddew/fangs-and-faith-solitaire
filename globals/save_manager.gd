extends Node

const SETTINGS_FILE_PATH: String = "res://settings.cfg"
var settings_config: ConfigFile = ConfigFile.new()
var load_settings_response: Error = settings_config.load(SETTINGS_FILE_PATH)

func get_value(section: String, key: String, default: Variant = null) -> Variant:
	return settings_config.get_value(section, key, default)
	
func set_value(section: String, key: String, value: Variant, save: bool = true) -> void:
	settings_config.set_value(section, key, value)
	if save:
		save_settings()
		
func get_game_settings() -> GameSettings:
	var game_settings: GameSettings = GameSettings.new()
	game_settings.game_mode = get_value("GAME", "MODE", "0")
	game_settings.rows = get_value("GAME", "ROWS", "6")
	game_settings.difficulty = get_value("GAME", "DIFFICULTY", "2")
	
	return game_settings

func save_settings() -> void:
	settings_config.save(SETTINGS_FILE_PATH)
