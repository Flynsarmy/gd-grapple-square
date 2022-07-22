extends Node


var stored: Dictionary = {}

func store(key: String, value) -> void:
	stored[key] = value
	
func getStored(key: String):
	return stored[key]
	
func delStored(key: String) -> bool:
	return stored.erase(key)
