extends Node

var steam_id = ""
var achievements: Dictionary = { 
	"WIN_1": false, "WIN_5": false, "WIN_10": false, "WIN_50": false, "WIN_100": false,
	"WIN_2_IN_A_ROW": false, "WIN_5_IN_A_ROW": false,  "WIN_10_IN_A_ROW": false,
	"WIN_PURE": false, "WIN_PRIEST": false, "WIN_VAMPIRE": false
}
var statistics: Dictionary = {
	"wins": 0,
	"nr_consecutive_wins": 0,
}

signal steamworks_error

func _ready():
	initialize_steam()

	var is_running = Steam.isSteamRunning()
	
	if not is_running:
		return
	
	steam_id = Steam.getSteamID()

func initialize_steam() -> void:
	if not Steam.isSteamRunning():
		return

	var initialize_response: Dictionary = Steam.steamInitEx()

	if initialize_response['status'] != Steam.STEAM_API_INIT_RESULT_OK:
		steamworks_error.emit("Failed to initialized Steam! Fangs & Faith Solitaire will now shut down. Check your log files to find out more.")
		return
	
	#Steam.current_stats_received.connect(_on_steam_stats_ready)
	load_steam_stats()
	load_steam_achievements()

func _on_steam_stats_ready(this_game: int, this_result: int, this_user: int) -> void:
	print("Player stats:")
	print("Game: ", this_game)
	print("Result: ", this_result)
	print("User: ", this_user)
	
	# These will check against the data we pulled in the initialization tutorial
	if this_user != steam_id:
		print("These stats belong to {0} instead, aborting Steam stat and achievement loading".format([this_user]))
		return

	if this_game != int(Steam.getAppID()):
		print("Stats are for a different app ID: {0}".format([this_game]))
		return

	if this_result != Steam.RESULT_OK:
		print("Failed to get stats and achievements from Steam: {0}".format(this_result))
		return
		
	load_steam_stats()
	load_steam_achievements()
	#
## Process statistics
func load_steam_stats() -> void:
	for this_stat in statistics.keys():
		var steam_stat: int = Steam.getStatInt(this_stat)

		# The set_statistic function below in the Setting Statistics section
		if statistics[this_stat] > steam_stat:
			print("Stat mismatch; local value is higher (%s), replacing Steam value (%s)" % [statistics[this_stat], steam_stat])
			set_statistic(this_stat, statistics[this_stat])

		elif statistics[this_stat] < steam_stat:
			print("Stat mismatch; local value is lower (%s), replacing with Steam value (%s)" % [statistics[this_stat], steam_stat])
			set_statistic(this_stat, steam_stat)

		else:
			print("Steam stat matches local file: %s" % this_stat)

	print("Steam statistics loaded")


# Process achievements
func load_steam_achievements() -> void:
	for this_achievement in achievements.keys():
		var steam_achievement: Dictionary = Steam.getAchievement(this_achievement)

		# The set_achievement function is below in the Setting Achievements section
		if not steam_achievement['ret']:
			print("Steam does not have this achievement, defaulting to local value: achieve%s" % this_achievement)
			continue

		if achievements[this_achievement] == steam_achievement['achieved']:
			print("Steam achievements match local file, skipping: %s" % this_achievement)
			continue

		set_achievement(this_achievement)

	print("Steam achievements loaded")

func set_achievement(this_achievement: String) -> void:
	if not achievements.has(this_achievement):
		print("This achievement does not exist locally: %s" % this_achievement)
		return
	achievements[this_achievement] = true

	if not Steam.setAchievement(this_achievement):
		print("Failed to set achievement: %s" % this_achievement)
		return

	print("Set acheivement: %s" % this_achievement)

	# Pass the value to Steam then fire it
	if not Steam.storeStats():
		print("Failed to store data on Steam, should be stored locally")
		return

	print("Data successfully sent to Steam")
	
func unset_achievement(this_achievement: String) -> void:
	if not achievements.has(this_achievement):
		print("This achievement does not exist locally: %s" % this_achievement)
		return
	achievements[this_achievement] = false

	if not Steam.clearAchievement(this_achievement):
		print("Failed to set achievement: %s" % this_achievement)
		return

	print("Set acheivement: %s" % this_achievement)

	# Pass the value to Steam then fire it
	if not Steam.storeStats():
		print("Failed to store data on Steam, should be stored locally")
		return

	print("Data successfully sent to Steam")
	
func set_statistic(this_stat: String, new_value: int = 0) -> void:
	if not statistics.has(this_stat):
		print("This statistic does not exist locally: %s" % this_stat)
		return
	statistics[this_stat] = new_value

	if not Steam.setStatInt(this_stat, new_value):
		print("Failed to set stat %s to: %s" % [this_stat, new_value])
		return

	print("Set statistics %s succesfully: %s" % [this_stat, new_value])


	# Pass the value to Steam then fire it
	if not Steam.storeStats():
		print("Failed to store data on Steam, should be stored locally")
		return

	print("Data successfully sent to Steam")
	
func unset_statistic(this_stat: String, new_value: int = 0) -> void:
	if not statistics.has(this_stat):
		print("This statistic does not exist locally: %s" % this_stat)
		return
	statistics[this_stat] = new_value

	if not Steam.setStatInt(this_stat, new_value):
		print("Failed to set stat %s to: %s" % [this_stat, new_value])
		return

	print("Set statistics %s succesfully: %s" % [this_stat, new_value])


	# Pass the value to Steam then fire it
	if not Steam.storeStats():
		print("Failed to store data on Steam, should be stored locally")
		return

	print("Data successfully sent to Steam")
