extends Node2D
class_name SoundQueue

@export var sound: AudioStreamMP3
@export var queue_size := 12
@export var volume_db: float

var current_index := 0

func _ready():
	for i in range(0, queue_size):
		var audio_instance: AudioStreamPlayer2D = AudioStreamPlayer2D.new()
		audio_instance.volume_db = volume_db
		add_child(audio_instance)

func update_volume(volume: float):
	for child in get_children():
		if child is AudioStreamPlayer2D:
			child.volume_db = volume

func get_current() -> AudioStreamPlayer2D:
	var current_player: AudioStreamPlayer2D = get_child(current_index)
	var tries_left = queue_size
	while current_player.playing and tries_left > 0:
		current_index = (current_index + 1) % queue_size
		current_player = get_child(current_index)
		tries_left -= 1
	
	current_index = (current_index + 1) % queue_size
	return current_player
	
func play(sound_stream: AudioStream, randomize_pitch: bool = true) -> AudioStreamPlayer2D:
	var current: AudioStreamPlayer2D = get_current()
	current.pitch_scale = 1.0
	current.set_stream(sound_stream)
	if randomize_pitch:
		current.pitch_scale = randf_range(0.9, 1.5)
	current.play()
	
	return current
