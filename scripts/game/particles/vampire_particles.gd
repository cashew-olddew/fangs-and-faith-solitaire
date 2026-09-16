extends Emitter
class_name VampireParticles

@onready var particles: CPUParticles2D = $VampireParticles
@onready var particles_overlay: CPUParticles2D = $VampireParticles_Overlay
@onready var burst_transform_particles: CPUParticles2D = $BurstTransformParticles
@onready var burst_transform_particles_overlay: CPUParticles2D = $BurstTransformParticles_Overlay
@onready var red_poof: GPUParticles2D = $RedPoof

func toggle_emit(emit, amount = 256, lifetime = .5) -> void:
	if emit:
		particles.amount = amount
		particles.lifetime = lifetime
		particles_overlay.amount = amount
		particles_overlay.lifetime = lifetime
	
		particles.emitting = true
		particles_overlay.emitting = true
	else:
		particles.emitting = false
		particles_overlay.emitting = false

func burst() -> void:
	burst_transform_particles.emitting = true
	burst_transform_particles_overlay.emitting = true

func burst_finished() -> void:
	await burst_transform_particles.finished
	await burst_transform_particles_overlay.finished

func poof() -> void:
	red_poof.emitting = true
