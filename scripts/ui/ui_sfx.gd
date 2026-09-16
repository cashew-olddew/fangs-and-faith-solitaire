extends Node

@onready var ui_sound_groups: Dictionary = {
	"Button": {
		"pressed": "Button_Click",
		"mouse_entered": "Button_Hover"
	},
	"OptionButton": {
		"mouse_entered": "Button_Hover",
		"pressed": "Dropdown_Click",
		"item_focused": "Dropdown_Hover",
		"item_selected": "Dropdown_Click",
	},
	"CheckBox": {
		"pressed": "CheckBox_Click"
	},
}
const SIGNALS_WITH_INDEX = ["item_selected", "item_focused"]

func _ready() -> void:
	var root: Node = get_tree().root
	# when _ready is called, there might already be nodes in the tree, so connect all existing buttons
	connect_nodes(root)

# recursively connect all buttons
func connect_nodes(root: Node) -> void:
	for child in root.get_children():
		connect_to_node(child)
		connect_nodes(child)

func _is_already_connected(node: Node, signal_name: String, callable: Callable) -> bool:
	for connection in node.get_signal_connection_list(signal_name):
		if str(connection.callable) == str(callable):
			return true
	return false
	
func connect_to_node(node: Node) -> void:
	var node_type: String = node.get_class()

	if node_type in ui_sound_groups.keys():
		for node_signal: String in ui_sound_groups[node_type]:
			var func_name: String = "_play_ui_sound" if not node_signal in SIGNALS_WITH_INDEX else "_play_ui_sound_with_index"
			var callable := Callable(self, func_name).bind(ui_sound_groups[node_type][node_signal], node)

			if not _is_already_connected(node, node_signal, callable):
				node.connect(node_signal, callable)
				
func _play_ui_sound(sound: String, node: Node) -> void:
	if node is Control and node.is_disabled():
		return
	SoundManager.play_ui_sound(sound)

func _play_ui_sound_with_index(_index: int, sound: String, node: Node) -> void:
	_play_ui_sound(sound, node)
