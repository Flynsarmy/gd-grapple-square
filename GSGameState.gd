extends Node

var score: int = 0 setget _set_score
var high_score: int = 0

func _ready() -> void:
	if GsEvents.connect("distance_marker_reached", self, "_on_distance_marker_reached") != OK:
		print(self.filename, ": Error connecting to distance_marker_reached signal.")

func _on_distance_marker_reached(number: int) -> void:
	# Must use self. or setget won't work
	self.score = number

func _set_score(new_score: int) -> void:
	score = new_score
	if new_score > high_score:
		high_score = new_score
