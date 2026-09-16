@tool
extends Node

@onready var label_left: Label = $LabelLeft
@onready var label_right: Label = $LabelRight

@export var left: String:
	set(value):
		left = value
		
@export var right: String:
	set(value):
		right = value

func _ready() -> void:
	label_left.text = left
	label_right.text = right
