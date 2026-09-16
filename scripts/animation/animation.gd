extends Node2D
class_name SpecialAnimation

const DARKEN_SHADER = preload("res://shaders/darken.gdshader")

var initial_placement: Vector2
var screen_center: Vector2

func _ready():
	screen_center = get_viewport().get_visible_rect().size / 2

func play_unleash_animation(dual: bool = false):
	var is_priest = owner.suit == Utils.Suit.black
	var particles = owner.particles_scene.instantiate()
	add_child(particles)
	
	var target_position = screen_center
	if dual:
		var card_offset = screen_center.x - owner.back.get_size().x / 2 \
			if owner.suit == Utils.Suit.black \
			else screen_center.x + owner.back.get_size().x / 2
		target_position = Vector2(card_offset, screen_center.y)

	await animate_unleash(target_position)
	particles.toggle_emit(true, 2048, 0.25)
	var shake_sound = SoundManager.play_sound("Card_Shake")
	await shake(20)
	SoundManager.play_sound("Card_Woosh")
	await animate_return()
	shake_sound.stop()
	
	SoundManager.play_sound(owner.special_effect_sounds[owner.suit]["unleash"])
	particles.toggle_emit(false)
	particles.poof()
	
func animate_unleash(target_position: Vector2):
	var tween = get_tree().create_tween().set_parallel(true)
	tween.tween_method(
		curve_tween_position.bind(target_position),
		0.0,
		1.0,
		1
	).set_ease(Tween.EASE_OUT).set_trans(Tween.TRANS_QUINT)
	tween.tween_property(
		owner,
		"scale",
		owner.scale * 3,
		1
	).set_ease(Tween.EASE_OUT).set_trans(Tween.TRANS_QUINT)
	
	await tween.finished

func animate_return():
	var tween = get_tree().create_tween().set_parallel(true)
	tween.tween_property(
		owner,
		"scale",
		owner.scale / 3,
		0.25
	).set_ease(Tween.EASE_IN).set_trans(Tween.TRANS_QUINT)
	tween.tween_property(
		owner,
		"global_position",
		owner.current_placement,
		0.25
	).set_ease(Tween.EASE_IN).set_trans(Tween.TRANS_EXPO)
	await tween.finished

func tween_material_shader_parameter(
	tween: Tween, material: ShaderMaterial, 
	param: StringName, start_value: Variant, end_value: Variant, 
	duration: float
	):
	tween.tween_method(
		func(value): material.set_shader_parameter(param, value),
		start_value,
		end_value,
		1.0
	)

func curve_tween_position(t: float, new_position: Vector2):
	var control_point = calculate_control_point(initial_placement, new_position, 200)
	owner.global_position = quadratic_bezier(initial_placement, control_point, new_position, t)

func calculate_control_point(start: Vector2, end: Vector2, offset: float) -> Vector2:
	var midpoint = (start + end) / 2
	var direction = (end - start).normalized()

	var perpendicular = Vector2(-direction.y, direction.x)
	
	return midpoint + perpendicular * offset

func quadratic_bezier(p0: Vector2, p1: Vector2, p2: Vector2, t: float):
	var q0 = p0.lerp(p1, t)
	var q1 = p1.lerp(p2, t)
	
	var r = q0.lerp(q1, t)
	return r

func shake(count: int):
	var shake_duration = 0.75
	var shake_intensity = 15
	var tween = create_tween()

	for i in range(count):
		tween.tween_property(
			owner, 
			"position",
			owner.position + Vector2(
				randf_range(-shake_intensity, shake_intensity),
				0.0
				),
			shake_duration / count
			)
	
	await tween.finished
