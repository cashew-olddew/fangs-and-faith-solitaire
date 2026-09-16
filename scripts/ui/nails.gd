extends Node

func _ready() -> void:
	set_event_sounds()

func set_event_sounds() -> void:
	var children = get_children()
	for child in children:
		child.connect("mouse_entered", _on_nail_button_mouse_entered)
		child.connect("pressed", _on_nail_button_pressed)

func _on_nail_button_mouse_entered() -> void:
	SoundManager.play_sound("Nail_Hover")

func _on_nail_button_pressed() -> void:
	SoundManager.play_sound("Nail_Click")
