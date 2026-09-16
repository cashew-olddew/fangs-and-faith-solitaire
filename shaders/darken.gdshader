shader_type canvas_item;

uniform float lod: hint_range(0.0, 5.0) = 5.0;
uniform sampler2D screen_texture : hint_screen_texture, filter_linear_mipmap;
uniform float mix_percentage: hint_range(0.0, 1.0) = 0.3;
uniform vec4 darken_color : source_color = vec4(0.0);

void fragment() {
	vec4 color = texture(screen_texture, SCREEN_UV, lod);
	COLOR = mix(color, darken_color, mix_percentage);
}