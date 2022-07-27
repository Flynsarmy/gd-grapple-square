extends Node

class_name GSCustomizationManager

const AVATARS: Dictionary = {
	"default": {
		"price": 0,
		"sprite": "res://assets/player/default.png",
		"color": "47cbbc",
	},
	"godot": {
		"price": 500,
		"sprite": "res://icon.png",
		"color": "",
	}
}

var avatars_unlocked = ["default"]
var avatar: String = "default"

func get_save_data() -> Dictionary:
	return {
		"avatars_unlocked": avatars_unlocked,
		"avatar": avatar,
	}

func load_save_data(data: Dictionary) -> void:
	var keys: Array = ["avatars_unlocked", "avatar"]
	for key in keys:
		if data.has(key):
			self[key] = data.get(key)
