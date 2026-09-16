extends Camera2D

@export var RANDOM_SHAKE_STRENGTH: float = 30.0
@export var SHAKE_DECAY_RATE: float = 5.0
@export var NOISE_SHAKE_SPEED: float = 30.0
@export var NOISE_SHAKE_STRENGTH: float = 60.0

var rand = RandomNumberGenerator.new()
var noise = FastNoiseLite.new()
var noise_value := 0.0
var current_shake_strength := 0.0

func _ready() -> void:
	rand.randomize()
	noise.seed = rand.randi()

func _input(event):
	if event.is_action_pressed("testshake"):
		apply_shake()

func apply_shake() -> void:
	current_shake_strength = NOISE_SHAKE_STRENGTH
	
func _process(delta: float) -> void:
	current_shake_strength = lerp(
		current_shake_strength, 0.0, 
		SHAKE_DECAY_RATE * delta
		)
	
	self.offset = get_noise_offset(delta)

func get_noise_offset(delta) -> Vector2:
	noise_value += delta * NOISE_SHAKE_SPEED
	
	return Vector2(
		noise.get_noise_2d(1, noise_value) * current_shake_strength,
		noise.get_noise_2d(100, noise_value) * current_shake_strength
	)
