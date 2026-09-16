extends Node

@onready var h_slider_sfx: HSlider = $HBoxSFXVolume/HSliderSFX
@onready var h_slider_music: HSlider = $HBoxMusicVolume/HSliderMusic

func _ready() -> void:
	h_slider_sfx.value = volume_to_slider_value(h_slider_sfx, SoundManager.get_saved_volume(SoundManager.VOLUME_TYPES.SFX))
	h_slider_music.value = volume_to_slider_value(h_slider_music, SoundManager.get_saved_volume(SoundManager.VOLUME_TYPES.BACKGROUND))

func volume_to_slider_value(slider: Slider, volume_db: float) -> float:
	# Handle mute case
	if volume_db <= SoundManager.ZERO_VOLUME or volume_db <= SoundManager.MINIMUM_DECIBELS:
		return slider.min_value
	
	# Reverse the exponential mapping
	var normalized_db = (volume_db - SoundManager.MINIMUM_DECIBELS) / (SoundManager.MAXIMUM_DECIBELS - SoundManager.MINIMUM_DECIBELS)
	var linear_value = pow(normalized_db, 1.0 / 0.3)  # Inverse of the 0.3 exponent
	return slider.min_value + linear_value * (slider.max_value - slider.min_value)

func _on_h_slider_sfx_drag_ended(_value_changed: bool) -> void:
	SoundManager.play_sound("Priest_Heal")

func _on_h_slider_sfx_value_changed(value: float) -> void:
	change_volume_with_slider(h_slider_sfx, value, SoundManager.VOLUME_TYPES.SFX)
	
func _on_h_slider_music_value_changed(value: float) -> void:
	change_volume_with_slider(h_slider_music, value, SoundManager.VOLUME_TYPES.BACKGROUND)
	
func change_volume_with_slider(slider: Slider, value: float, type: int) -> void:
	# Handle mute case (slider at minimum)
	if value <= slider.min_value:
		SoundManager.update_volume(SoundManager.ZERO_VOLUME, type)
		return
	
	# Use exponential mapping for better volume distribution
	var normalized_value = (value - slider.min_value) / (slider.max_value - slider.min_value)
	var exponential_value = pow(normalized_value, 0.3)  # 0.3 makes the curve more gradual
	var mapped_value = SoundManager.MINIMUM_DECIBELS + exponential_value * (SoundManager.MAXIMUM_DECIBELS - SoundManager.MINIMUM_DECIBELS)
	
	SoundManager.update_volume(mapped_value, type)
