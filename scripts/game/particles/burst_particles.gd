extends Node2D

@onready var red_particles: Node2D = $RedParticles
@onready var black_particles: Node2D = $BlackParticles

func get_particles_container(type: Utils.Suit) -> Node:
	return black_particles if type == Utils.Suit.black else red_particles

func burst_particles(particle: CPUParticles2D):
	particle.emitting = true

func burst(type: Utils.Suit = Utils.Suit.black):
	var container = get_particles_container(type)
	for particle in container.get_children():
		if particle is not CPUParticles2D:
			continue
		burst_particles(particle)
