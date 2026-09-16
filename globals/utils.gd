extends Node

func full_path(dir_path: String, file_name: String, file_type := '.png'):
	return str(dir_path, '/', file_name, file_type)

func enum_str(enum_type: Variant, value: int) -> String:
	# This breaks if enum_type is not an actual enum type.
	return enum_type.keys()[value]

func capitalize_first_letter(text: String) -> String:
	return text[0].to_upper() + text.substr(1,-1)

enum CARD_STATE {
	Return,
	Idle,
	InHand,
	Collected
}

enum Suit {
	red,
	black
}

enum Characters {
	woman,
	man
}

enum SpecialCharacters { 
	vampire,
	priest
}
