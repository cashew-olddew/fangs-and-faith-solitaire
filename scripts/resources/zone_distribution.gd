class_name ZoneDistribution
extends Resource

@export var number := 5
@export var container_margin := Vector2(300, 100)

func _init(rows):
	self.number = rows
	self.container_margin = Vector2(300, 480 / rows)
