extends MarginContainer

var children: Array[Node]
var current_child: int = 0

signal quit

func _ready() -> void:
	children = get_children()
	
	if children.size():
		children[current_child].visible = true
		
	for child in children:
		if child is TutorialBox:
			child.connect("next_pressed", next_pressed)
			child.connect('previous_pressed', previous_pressed)
			child.connect("quit_pressed", quit_pressed)
	pass

func next_pressed() -> void:
	current_child = posmod(current_child + 1, children.size())
	
	if current_child >= 0 && current_child < children.size():
		children[current_child - 1].visible = false
		children[current_child].visible = true
		
func previous_pressed() -> void:
	current_child = posmod(current_child - 1, children.size())

	children[current_child + 1].visible = false
	children[current_child].visible = true

func quit_pressed() -> void:
	quit.emit()
