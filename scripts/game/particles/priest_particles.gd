extends Emitter
class_name PriestParticles

@onready var priest_particles: CPUParticles2D = $PriestParticles
@onready var burst_transform_particles: CPUParticles2D = $BurstTransformParticles
@onready var black_poof: CPUParticles2D = $BlackPoof

func toggle_emit(emit = true, amount = 256, lifetime = .5):
	if emit:
		priest_particles.amount = amount
		priest_particles.lifetime = lifetime
		priest_particles.emitting = true
	else:
		priest_particles.emitting = false
	
func burst():
	burst_transform_particles.emitting = true

func burst_finished():
	await burst_transform_particles.finished
	burst_transform_particles.queue_free()

func poof():
	black_poof.emitting = true
