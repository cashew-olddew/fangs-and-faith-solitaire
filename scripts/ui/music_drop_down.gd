extends LabeledDropDown

@export_dir var music_folder_location: String = ""

func apply_option_changes(option: String) -> void:
	var previous_song_name: String = SaveManager.get_value(
		save_file_settings.group, save_file_settings.property, default_option)
	
	var new_song: AudioStream = null
	
	# Apply default song if no song was selected
	if not previous_song_name:
		new_song = load(music_folder_location + '/' + default_option)
	else:
		new_song = load(music_folder_location + '/' + option)
	
	if option:
		new_song = load(music_folder_location + '/' + option)
		type_string(typeof(new_song))
	
	SoundManager.play_music(new_song)
