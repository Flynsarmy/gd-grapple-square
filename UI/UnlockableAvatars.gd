extends Control

const AVATAR_SPACING = 150
const SCN_UNLOCKABLE_AVATAR = preload("res://UI/UnlockableAvatar.tscn")

onready var container: Node2D = $AvatarsContainer

func _ready() -> void:
	var current_avatar = GsCustomizationManager.get_avatar_details()

	var index: int = 0
	for key in GsCustomizationManager.AVATARS:
		var node: UnlockableAvatar = SCN_UNLOCKABLE_AVATAR.instance()
		node.avatar = key
		container.add_child(node)
		node.position = Vector2(AVATAR_SPACING * (index - current_avatar.get("index")), 0)

		index += 1
