extends LabeledDropDown

func get_fallback_language() -> String:
	var os_language: String = OS.get_locale_language()
	return os_language if os_language in options else default_option

func apply_option_changes(option: String) -> void:
	if not option:
		option = get_fallback_language()

	TranslationServer.set_locale(option)

func get_saved_option() -> String:
	var fallback_language: String = get_fallback_language()
	return SaveManager.settings_config.get_value(
		save_file_settings.group,
		save_file_settings.property,
		fallback_language
	)
