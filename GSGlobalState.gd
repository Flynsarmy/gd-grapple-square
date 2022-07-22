extends Node

var state: Dictionary = {}

func store(key: String, value):
	state[key] = value
	
func getStored(key: String):
	return state[key]
