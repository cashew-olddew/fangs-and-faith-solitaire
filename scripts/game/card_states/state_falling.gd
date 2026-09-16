extends State
class_name FallingState

var velocity := Vector2.ZERO
const GRAVITY := 50.0

func enter(data := {}):
	SoundManager.play_sound("Card_Move")
	pass

func update(delta: float) -> void:
	velocity += GRAVITY * delta * Vector2.DOWN
	owner.position += velocity

func handle_input(_event: InputEvent) -> void:
	pass

func exit() -> void:
	pass
