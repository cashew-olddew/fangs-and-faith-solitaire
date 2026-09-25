class_name GameWonState
extends State

func _ready():
	state_machine = get_parent()

func enter(_data := {}) -> void:
	var o: BoardManager = owner
	o.input_blocker.set_visible(true)
	o.animation_manager.spin_animation_manager.animate()
	o.game_state_changed.emit(name)
	
	if not BoardManager.is_replay:
		update_achievements()
		
func update_achievements():
	var wins = SteamManager.statistics.get("wins", 0) + 1
	SteamManager.set_statistic("wins", wins)
	
	match wins:
		1: SteamManager.set_achievement("WIN_1")
		5: SteamManager.set_achievement("WIN_5")
		10: SteamManager.set_achievement("WIN_10")
		50: SteamManager.set_achievement("WIN_50")
		100: SteamManager.set_achievement("WIN_100")

	var nr_consecutive_wins = SteamManager.statistics.get("nr_consecutive_wins", 0) + 1
	SteamManager.set_statistic("nr_consecutive_wins", nr_consecutive_wins)

	match nr_consecutive_wins:
		2: SteamManager.set_achievement("WIN_2_IN_A_ROW")
		5: SteamManager.set_achievement("WIN_5_IN_A_ROW")
		10: SteamManager.set_achievement("WIN_10_IN_A_ROW")

	if StatsManager.transformed_by_priest == 0 and StatsManager.transformed_by_vampire == 0 and owner.game_settings.game_mode == "0":
		SteamManager.set_achievement("WIN_PURE")
	if StatsManager.transformed_by_priest >= 10:
		SteamManager.set_achievement("WIN_PRIEST")
	if StatsManager.transformed_by_vampire >= 10:
		SteamManager.set_achievement("WIN_VAMPIRE")
