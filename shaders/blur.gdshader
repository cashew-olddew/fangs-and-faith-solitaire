shader_type canvas_item;

uniform sampler2D screen_texture : hint_screen_texture, filter_linear_mipmap;
uniform float speed: hint_range(0.0, 5.0);
uniform float blur_amount: hint_range(0.0, 2.0) = 1.5;

void fragment() {
	float animated_amount = blur_amount + 0.5 * sin(TIME * speed);
	COLOR = textureLod(screen_texture, SCREEN_UV, animated_amount);
}