extends Node

var score: int = 0 setget _set_score
var high_score: int = 0
var coins: int = 0
var games_played: int = 0

func _ready() -> void:
	_connect_signal("coin_acquired", self, "_on_coin_acquired")
	_connect_signal("distance_marker_reached", self, "_on_distance_marker_reached")
	_connect_signal("started_new_game", self, "_on_started_new_game")

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
