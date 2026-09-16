extends Node2D

@onready var normals: Node2D = $Normals
@onready var specials = $Specials
@onready var metals: Node2D = $Metals
@onready var collectors: Node2D = $Collectors

const ZONE_SCENE: PackedScene = preload("res://scenes/game/normal_zone.tscn")
const NORMAL_ZONE_TEXTURE = "res://assets/zones/transparent_white_square_small.png"
const BACKGROUND_HEIGHT = 1080

func initialize_zones() -> void:
	var rows = owner.game_settings.rows
	var zone_distribution: ZoneDistribution = ZoneDistribution.new(rows)
	for i in range(0, zone_distribution.number):
		var zone: Zone = ZONE_SCENE.instantiate()
		zone.set_name(str("NormalZone", i))
		zone.texture = load(NORMAL_ZONE_TEXTURE)
		normals.add_child(zone)
		
		var zone_height = zone.sprite_2d.texture.get_height()
		var total_space_between: float = BACKGROUND_HEIGHT - \
			zone_distribution.container_margin.y * 2 - zone_height * zone_distribution.number
		var space_between: float = total_space_between / (zone_distribution.number - 1)
		
		zone.global_position = Vector2(
			zone_distribution.container_margin.x,
			zone_distribution.container_margin.y + i * (zone_height + space_between) + zone_height / 2
		)
	listen_to_collector_events()

func listen_to_collector_events() -> void:
	for collector in collectors.get_children():
		collector.connect("collector_clicked", owner._on_collector_clicked)
		
