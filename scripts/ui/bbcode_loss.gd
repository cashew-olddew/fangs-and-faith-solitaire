@tool
extends RichTextEffect
class_name LossEffect

var bbcode = "loss"

func _process_custom_fx(char_fx: CharFXTransform):

	var color_a := Color(1.0, 0.0, 0.0, 0.0)     # Red
	var color_b := Color(1.0, 0.0, 0.0, 1.0)   # Gold

	var time := char_fx.elapsed_time / 5.
	char_fx.color = color_a.lerp(color_b, time)
	
	return true
