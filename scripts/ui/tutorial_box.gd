extends PanelContainer

class_name TutorialBox

@export_multiline var text: String = ""
@export var texture: Texture2D = null
@export var is_first: bool = false
@export var is_last: bool = false
@export var progress_pages: int = 1
@export var total_pages: int = 10

@onready var text_label: RichTextLabel = $VBoxTutorialAndControls/HBoxTutorial/Text
@onready var image: TextureRect = $VBoxTutorialAndControls/HBoxTutorial/Image
@onready var button_prev: Button = $VBoxTutorialAndControls/HBoxControls/ButtonPrev
@onready var button_next: Button = $VBoxTutorialAndControls/HBoxControls/ButtonNext
@onready var label_progress: Label = $VBoxTutorialAndControls/LabelProgress

signal previous_pressed
signal next_pressed
signal quit_pressed

func _ready() -> void:
	text_label.text = text
	image.texture = texture
	label_progress.text = "{0}/{1}".format([progress_pages, total_pages])
	
	if is_first:
		button_prev.disabled = true
		button_prev.focus_mode = Control.FOCUS_NONE
	if is_last:
		button_next.text = "FINISH"
	pass

func _on_quit_button_mouse_entered() -> void:
	SoundManager.play_ui_sound("Button_Hover")

func _on_quit_button_pressed() -> void:
	SoundManager.play_ui_sound("Esc")
	quit_pressed.emit()

func _on_button_prev_pressed() -> void:
	previous_pressed.emit()

func _on_button_next_pressed() -> void:
	if is_last:
		quit_pressed.emit()
		return
	next_pressed.emit()
