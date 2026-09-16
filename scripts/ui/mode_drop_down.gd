extends LabeledDropDown

func apply_option_changes(option: String) -> void:
	SaveManager.set_value(
		save_file_settings.group, 
		save_file_settings.property, 
		option
	)
