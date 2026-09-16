extends Node2D

@onready var red_particles: Node2D = $RedParticles
@onready var black_particles: Node2D = $BlackParticles

func get_particles_container(type: Utils.Suit) -> Node:
	return black_particles if type == Utils.Suit.black else red_particles

func toggle_particles(particle: CPUParticles2D, emit: bool, amount: int, lifetime: float):
	if emit:
		particle.amount = amount
		particle.lifetime = lifetime
		particle.emitting = true
	else:
		particle.emitting = false

func toggle_emit(type: Utils.Suit = Utils.Suit.black, emit = true, amount = 256, lifetime = .5):
	var container = get_particles_container(type)
	for particle in container.get_children():
		if particle is not CPUParticles2D:
			continue
		toggle_particles(particle, emit, amount, lifetime)
