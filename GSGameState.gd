extends Node

var score: int = 0 setget _set_score
var high_score: int = 0
var coins: int = 0
var games_played: int = 0
var continue_cost: int = 10 # warning-ignore:unused_class_variable

var saveable_properties = ["high_score", "coins", "games_played"]
var save_game_filepath = "user://grapplesquare.dat"

func _ready() -> void:
	_connect_signal("coin_acquired", self, "_on_coin_acquired")
	_connect_signal("distance_marker_reached", self, "_on_distance_marker_reached")
	_connect_signal("started_new_game", self, "_on_started_new_game")
	
	load_game()
	
func save_game() -> void:
	# Collect our save data into a Dictionary
	var save_data: Dictionary = {}
	for property in saveable_properties:
		save_data[property] = self[property]
	
	# Do the saving
	var save_game: File = File.new()
	if save_game.open(save_game_filepath, File.WRITE) != OK:
		print(self.filename, ": Error opening save file for writing")
		return
	save_game.store_line(to_json(save_data))
	save_game.close()
	
func load_game() -> void:
	var save_game = File.new()
	
	# Make sure the file exists
	if not save_game.file_exists(save_game_filepath):
		return # Error! We don't have a save to load.
		
	# Make sure the file is readable
	if save_game.open(save_game_filepath, File.READ) != OK:
		print(self.filename, ": Error opening save file for reading")
		return
	
	# Get the saved dictionary from the next line in the save file
	var save_data: Dictionary = parse_json(save_game.get_line())
	
	for property in saveable_properties:
		if save_data.has(property):
			self[property] = save_data[property]
	
	save_game.close()

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
