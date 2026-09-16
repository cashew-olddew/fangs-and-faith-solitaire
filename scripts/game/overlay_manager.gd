extends Node2D
class_name OverlayManager

@onready var darken_overlay = $DarkenOverlay
@onready var blur_overlay = $BlurOverlay

func toggle_darken(darken: bool):
	var tween = create_tween().set_parallel(true)
	var shader_material = darken_overlay.material
	
	if darken:
		# Set initial values before making visible to prevent flickering
		shader_material.set_shader_parameter("lod", 0.0)
		shader_material.set_shader_parameter("mix_percentage", 0.0)
		darken_overlay.visible = darken
		tween_material_shader_parameter(tween, shader_material, "lod", 0.0, 0.2, 1.2)
		tween_material_shader_parameter(tween, shader_material, "mix_percentage", 0.0, 0.5, 1.2)
	else:
		tween_material_shader_parameter(tween, shader_material, "lod", 0.2, 0.0, 0.5)
		tween_material_shader_parameter(tween, shader_material, "mix_percentage", 0.5, 0.0, 0.5)
		await tween.finished
		darken_overlay.visible = darken

func tween_material_shader_parameter(
	tween: Tween, shader_material: ShaderMaterial, 
	param: StringName, start_value: Variant, end_value: Variant, 
	duration: float
	):
	tween.tween_method(
		func(value): shader_material.set_shader_parameter(param, value),
		start_value,
		end_value,
		duration
	)
