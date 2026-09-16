extends Node2D

const BACKGROUND = preload("res://assets/backgrounds/background.png")

func exit_to_desktop() -> void:
	get_tree().quit()

func _on_blur_container_exited_to_menu() -> void:
	#print("Exiting to menu")
	pass

func _ready():
	StatsManager.clear_stats()
