extends Node

const ZERO_VOLUME: int = -300
const MINIMUM_DECIBELS: int = -60
const MAXIMUM_DECIBELS: int = -5

@onready var music_player: AudioStreamPlayer = $MusicPlayer
@onready var sound_queue: SoundQueue = $SoundQueue

enum VOLUME_TYPES { SFX, BACKGROUND }

var _game_sound_pool: Dictionary

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	music_player.connect("finished", Callable(self, "_on_loop_sound").bind(music_player))
	#TODO put the volumes in global variables to reduce the calls to the file system
	var background_volume = get_saved_volume(VOLUME_TYPES.BACKGROUND)
	var effects_volume = get_saved_volume(VOLUME_TYPES.SFX)
	_game_sound_pool = {
		"Card_Move"      : load_sounds_from_folder("res://assets/sounds/sfx/cards/card move/"),
		"Card_Hover"	 : load_sounds_from_folder("res://assets/sounds/sfx/cards/card hover/"),
		"Card_Draw"	 	 : load_sounds_from_folder("res://assets/sounds/sfx/cards/card draw/"),
		"Card_Discard"   : load_sounds_from_folder("res://assets/sounds/sfx/cards/card discard/"),
		"Card_Collect"	 : load_sounds_from_folder("res://assets/sounds/sfx/cards/card collect/"),
		"Card_Woosh"	 : load_sounds_from_folder("res://assets/sounds/sfx/cards/card woosh/"),
		"Card_Shake"	 : load_sounds_from_folder("res://assets/sounds/sfx/cards/card shake/"),
		"Priest_Uncover" : load_sounds_from_folder("res://assets/sounds/sfx/cards/priest uncover/"),
		"Vampire_Uncover": load_sounds_from_folder("res://assets/sounds/sfx/cards/vampire uncover/"),
		"Priest_Heal"    : load_sounds_from_folder("res://assets/sounds/sfx/cards/priest heal/"),
		"Vampire_Bite"   : load_sounds_from_folder("res://assets/sounds/sfx/cards/vampire bite/"),
		"Nail_Hover"	 : load_sounds_from_folder("res://assets/sounds/ui/buttons/nail hover/"),
		"Nail_Click"	 : load_sounds_from_folder("res://assets/sounds/ui/buttons/nail click/"),
		"Victory"		 : load_sounds_from_folder("res://assets/sounds/sfx/events/victory/"),
		"Defeat"         : load_sounds_from_folder("res://assets/sounds/sfx/events/defeat/"), 
		# UI SOUNDS
		"Button_Hover"  : load("res://assets/sounds/ui/buttons/generic hover/UI_Select_2.wav"),
		"Button_Click"  : load("res://assets/sounds/ui/buttons/generic click/UI_Click_2.wav"),
		"CheckBox_Click" : load("res://assets/sounds/ui/buttons/generic click/UI_Click_3.wav"),
		"Dropdown_Hover" : load("res://assets/sounds/ui/buttons/generic hover/UI_Select_1.wav"),
		"Dropdown_Click" : load("res://assets/sounds/ui/buttons/generic click/UI_Click_1.wav"),
		"Esc": load("res://assets/sounds/ui/buttons/pause game/GP_Discard_1.wav")
	}

	update_volume(background_volume, VOLUME_TYPES.BACKGROUND)
	update_volume(effects_volume, VOLUME_TYPES.SFX)

func _on_loop_sound(player: AudioStreamPlayer) -> void:
	player.stream_paused = false
	player.play()

func get_saved_volume(type: VOLUME_TYPES) -> float:
	var volume_type: String = VOLUME_TYPES.keys()[type]
	return SaveManager.get_value("SOUND", volume_type, -15.0)

func update_volume(volume_db: float, type: VOLUME_TYPES) -> void:
	# Polymorphism is overengineering for this case in my oppinion
	match type:
		VOLUME_TYPES.SFX:
			if volume_db > MINIMUM_DECIBELS:
				volume_db = volume_db
			sound_queue.update_volume(volume_db)
		VOLUME_TYPES.BACKGROUND:
			music_player.volume_db = volume_db
		_:
			print("You shouldn't be here...")
			return;

	var volume_type: String = VOLUME_TYPES.keys()[type]
	SaveManager.set_value("SOUND", volume_type, volume_db)

func load_sounds_from_folder(path: String) -> Array[AudioStream]:
	var audio_streams: Array[AudioStream] = []
	var files_in_dir: PackedStringArray = DirAccess.get_files_at(path)
	for file: String in files_in_dir:
		if file.ends_with(".import"):
			var file_name: String = file.replace(".import", "")
			var tmp: AudioStream = load(path + file_name)
			audio_streams.append(tmp)
	return audio_streams

func play_sound(sound_name: String, randomize_pitch: bool = true) -> AudioStreamPlayer2D:
	if not _game_sound_pool.has(sound_name):
		print("Sound {0} not found".format([sound_name]))
		return

	var sounds = _game_sound_pool[sound_name]
	var sound_to_be_played = null
	
	if sounds is Array:
		sound_to_be_played = sounds.pick_random()
	else:
		sound_to_be_played = sounds

	return sound_queue.play(sound_to_be_played, randomize_pitch)

func play_ui_sound(sound_name: String) -> void:
	play_sound(sound_name, false)
	
func play_music(song: Resource) -> void:
	if song != music_player.stream:
		music_player.stream = song
		music_player.play()
