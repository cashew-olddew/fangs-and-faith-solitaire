shader_type canvas_item;

uniform sampler2D sample_tex;
uniform sampler2D noise_tex;
uniform sampler2D gradient_tex; // horizontal gradient
uniform float glow_thickness : hint_range(0.0, 1.0, 0.1) = 0.5;
uniform float pulse_speed = 2.0;
uniform float rotation_speed = 1.0;

void fragment() {
    vec2 centered_uv = UV - vec2(0.5);

	float angle = atan(centered_uv.y, centered_uv.x);
    float radius = length(centered_uv);
    float rotated_angle = angle + TIME * rotation_speed;
    vec2 rotated_uv = vec2(cos(rotated_angle), sin(rotated_angle)) * radius;

	float noise_val = texture(noise_tex, fract(rotated_uv)).r;
    float base_alpha = texture(sample_tex, UV).a;
    float pulse = 0.75 + 0.5 * sin(TIME * pulse_speed);

	float glow_alpha = base_alpha * glow_thickness * noise_val * pulse;

    // Sample gradient using radius as x coord
    vec4 glow_color = texture(gradient_tex, vec2(clamp(radius, 0.0, 1.0), 0.5));

	// Experiment with this...
	float radial_fade = smoothstep(0.6, 0.2, radius);
	glow_alpha *= radial_fade;

    COLOR = vec4(glow_color.rgb, glow_alpha * glow_color.a);
}
