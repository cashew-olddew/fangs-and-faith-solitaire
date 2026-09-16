extends Control

@export_file var next_scene: String = "res://scenes/game/game.tscn"
@onready var progress_bar: ProgressBar = $ProgressBar
@onready var color_rect: ColorRect = $ColorRect

# I'm using a timer node because I'm waiting for the timeout in the process
# and I want to make sure I don't ever create new timers in case of errors.
# This timer exists because I think it is nice for the user to see 100% for a
# split second before having the scene swapped.
@onready var timer: Timer = $Timer

var last_progress = 0.0

func _ready() -> void:
	ResourceLoader.load_threaded_request(next_scene, "")
	create_tween().tween_property(
		color_rect, "color",
		Color(color_rect.color, 0.5),
		0.5
	)

# load_threaded_get_status updates the progress once in a while
# For example, before completing the loading it might return: 0.3, 0.5, 1.0
# That's why this function lerps between the new progress values
# To make it look like the progress is smooth
func _process(delta: float) -> void:
	# Arrays are passed by reference, thus, the load_threaded_get_status
	# needs a one-element array as a parameter for efficiency reasons
	var progress = [] 
	var loaded_status := ResourceLoader.load_threaded_get_status(next_scene, progress)
	var new_progress = progress[0] * 100.0
	if new_progress > last_progress:
		last_progress = new_progress
	
	progress_bar.value = lerp(progress_bar.value, last_progress, delta * 5)
	if loaded_status == ResourceLoader.ThreadLoadStatus.THREAD_LOAD_LOADED:
		progress_bar.value = 100
		var packed_next_scene = ResourceLoader.load_threaded_get(next_scene)
		timer.start()
		await timer.timeout
		get_tree().change_scene_to_packed(packed_next_scene)
		
