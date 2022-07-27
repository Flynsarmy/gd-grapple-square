extends Node

const AVATAR_SIZE: int = 60 # Size in pixels of each sprite in the spritesheet
const AVATARS: Dictionary = {
	"default": {
		"price": 0,
		"color": "47cbbc"
	},
	"brown_haired_girl": {
		"price": 75,
		"color": "330F10"
	},
	"blonde_girl": {
		"price": 75,
		"color": "FFD800"
	},
	"masked_man": {
		"price": 150,
		"color": "000000"
	},
	"ghost": {
		"price": 150,
		"color": "33A8ED"
	},
	"duck": {
		"price": 200,
		"color": "EECC01"
	},
	"orc": {
		"price": 200,
		"color": "129700"
	},
	"tophat": {
		"price": 300,
		"color": "000000"
	},
	"officer": {
		"price": 300,
		"color": "2454B9"
	},
	"commando": {
		"price": 300,
		"color": "565433"
	},
	"batsquare": {
		"price": 500,
		"color": "000000"
	},
	"birdsquare": {
		"price": 1000,
		"color": "EE1033"
	},
}

var avatars_unlocked = ["default"]
var avatar: String = "default"

func _ready() -> void:
	GsSaveManager.register("GSCustomizationManager", self)

# Returns a Dictionary of the current avatar's price, color and spritesheet offset
func get_avatar_details() -> Dictionary:
	var details: Dictionary = AVATARS.get(avatar)

	# Are we trying to swap to an avatar that doesn't exist? Swap back to the default one
	if details == null:
		print(self.filename, ": Details for avatar ", avatar, " missing. Swapping back to default.")
		swap_to_avatar("default")
		return get_avatar_details()

	details["offset"] = Vector2(max(0, AVATARS.keys().find(avatar)) * AVATAR_SIZE, 0)

	return details

# Attempts to unlock and swap to the new avatar. Returns false if the player
# can't afford the unlock.
func maybe_unlock_avatar(id: String) -> bool:
	var found: Dictionary = AVATARS.get(id)
	if !found:
		return false

	# Does they already own it?
	if id in avatars_unlocked:
		swap_to_avatar(id)
		GsSaveManager.save_game()
		return true

	# Can they afford it?
	if found.get("price") > GsGameState.coins:
		return false

	GsGameState.coins -= found.get("price")
	avatars_unlocked.append(id)

	swap_to_avatar(id)
	GsSaveManager.save_game()

	return true

# Swaps to the given avatar regardless of whether it's unlocked.
func swap_to_avatar(id: String) -> void:
	avatar = id

	GsEvents.emit_signal("avatar_changed", get_avatar_details())


# SAVE MANAGER FUNCTIONS

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
