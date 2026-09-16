class_name GameOverState
extends State

func _ready():
	state_machine = get_parent()

func enter(_data := {}) -> void:
	var o: BoardManager = owner
	o.input_blocker.set_visible(true)
	var all_cards = o.deck_manager.get_children()
	o.animation_manager.make_cards_fall(all_cards)
	o.game_state_changed.emit(name)

	update_steam_statistics()

func update_steam_statistics():
	SteamManager.set_statistic("nr_consecutive_wins", 0)
