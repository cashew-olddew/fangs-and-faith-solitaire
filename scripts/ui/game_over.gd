extends VBoxContainer

@onready var rich_text_label_game_over: RichTextLabel = $RichTextLabelGameOver
@onready var particles: CPUParticles2D = $Control/Particles

signal play_again_button_pressed
signal back_button_pressed

const FADE_DURATION = 1

func update_text(new_text: String):
	rich_text_label_game_over.text = new_text

func fade_out():
	var tween = get_tree().create_tween()
	tween.tween_property(
		self, "modulate:a", 1, FADE_DURATION
	).from(0)
	await tween.finished
	tween.kill()

func _on_button_back_to_menu_button_down() -> void:
	back_button_pressed.emit()

func _on_button_play_again_button_down() -> void:
	play_again_button_pressed.emit()
