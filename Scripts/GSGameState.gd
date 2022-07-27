extends Node

var score: int = 0 setget _set_score
var high_score: int = 0
var coins: int = 0
var games_played: int = 0
var continue_cost: int = 10 # warning-ignore:unused_class_variable

onready var customization_manager: GSCustomizationManager = \
	(load("res://Scripts/GSCustomizationManager.gd") as GDScript).new()

func _ready() -> void:
	_connect_signal("coin_acquired", self, "_on_coin_acquired")
	_connect_signal("distance_marker_reached", self, "_on_distance_marker_reached")
	_connect_signal("started_new_game", self, "_on_started_new_game")

	GsSaveManager.register("GSGameState", self)
	GsSaveManager.register("GSCustomizationManager", customization_manager)

	GsSaveManager.load_game()

func _on_coin_acquired() -> void:
	coins += 1

func _on_distance_marker_reached(number: int) -> void:
	# Must use self. or setget won't work
	self.score = number

func _on_started_new_game() -> void:
	games_played += 1
	# Must use self. or setget won't work
	self.score = 0

func _set_score(new_score: int) -> void:
	score = new_score
	if new_score > high_score:
		high_score = new_score

func _connect_signal(signal_name: String, target: Object, method: String) -> void:
	if GsEvents.connect(signal_name, target, method) != OK:
		print(self.filename, ": Error connecting to " + signal_name + " signal.")

func get_save_namespace() -> String:
	return "GSGameState"

func get_save_data() -> Dictionary:
	return {
		"high_score": high_score,
		"coins": coins,
		"games_played": games_played,
	}

func load_save_data(data: Dictionary) -> void:
	var keys: Array = ["high_score", "coins", "games_played"]
	for key in keys:
		if data.has(key):
			self[key] = data.get(key)
