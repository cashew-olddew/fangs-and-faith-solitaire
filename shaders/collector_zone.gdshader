shader_type canvas_item;

uniform vec4 glow_color : source_color = vec4(1.0, 1.0, 0.0, 1.0);
uniform float box_radius = 0.4;
uniform float corner_radius = 0.05;
uniform float softness = 0.05;
uniform float slowdown = 1.0;

uniform sampler2D glow_texture : hint_default_white;
uniform float texture_opacity = 0.5;
uniform float texture_scale = 1.0;

float roundedBoxSDF(vec2 p, vec2 size, float r) {
    vec2 d = abs(p) - size + vec2(r);
    return length(max(d, 0.0)) - r;
}

void fragment() {
    vec2 centered_uv = UV - vec2(0.5); // Center UV (-0.5 to 0.5)
    vec2 half_size = vec2(box_radius);

    float dist = roundedBoxSDF(centered_uv, half_size, corner_radius);
    float mask = smoothstep(softness, 0.0, dist);

	centered_uv.x += TIME / slowdown;

	centered_uv *= texture_scale;
    vec4 tex_color = texture(glow_texture, fract(centered_uv));
    float final_alpha = mix(glow_color.a, tex_color.a * tex_color.r, texture_opacity);
	COLOR = vec4(glow_color.rgb, final_alpha * mask * COLOR.a);
}
