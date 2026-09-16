@tool
extends RichTextEffect
class_name WinEffect

var bbcode = "win"

func _process_custom_fx(char_fx: CharFXTransform):
	var freq = char_fx.env.get("freq", 1.0)
	var amp = char_fx.env.get("amp", 1.0)
	var off = char_fx.env.get("off", 1.0)
	
	char_fx.offset.y = amp * sin(
		char_fx.elapsed_time * freq + char_fx.relative_index * off
	)
	
	char_fx.transform = char_fx.transform.rotated_local(
		0.05 * sin(char_fx.elapsed_time)
	)
	
	var time := char_fx.elapsed_time + char_fx.offset.x * 10.0
	var scale := 1.0 + 0.1 * sin(time * 2.0)
	char_fx.transform = char_fx.transform.scaled_local(
		Vector2.ONE * scale
	)
	#
	var color_a := Color(1.0, 0.0, 0.0)     # Red
	var color_b := Color.from_string("#f7cc34", Color.RED)    # Gold

	var t := 0.5 + 0.5 * sin(time * 2.0)  # Oscillates between 0 and 1
	char_fx.color = color_a.lerp(color_b, t)

	return true
