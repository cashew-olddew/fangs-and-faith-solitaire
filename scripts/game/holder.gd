extends Area2D
class_name Holder

func _can_place(card: Card) -> bool:
	return false

func _get_snapping_point() -> Vector2:
	return Vector2.ZERO
	
func _add_card(card: Card) -> void:
	pass
