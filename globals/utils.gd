extends Node

func full_path(dir_path: String, file_name: String, file_type := '.png'):
	return str(dir_path, '/', file_name, file_type)

func enum_str(enum_type: Variant, value: int) -> String:
	# This breaks if enum_type is not an actual enum type.
	return enum_type.keys()[value]

func capitalize_first_letter(text: String) -> String:
	return text[0].to_upper() + text.substr(1,-1)

# Array.pick_random/shuffle use the global RNG, which sounds and animations also consume
func pick_random(array: Array, rng: RandomNumberGenerator) -> Variant:
	return array[rng.randi_range(0, array.size() - 1)]

func shuffle(array: Array, rng: RandomNumberGenerator) -> void:
	for i in range(array.size() - 1, 0, -1):
		var j := rng.randi_range(0, i)
		var temp = array[i]
		array[i] = array[j]
		array[j] = temp

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
