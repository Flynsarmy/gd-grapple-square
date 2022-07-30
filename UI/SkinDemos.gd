extends Control

const AVATAR_SPACING = 200
const AVATAR_NORMAL_SCALE = 1
const AVATAR_SELECTED_SCALE = 3
const SHARD_COUNT = 8
const SCN_SKIN = preload("res://UI/SkinDemo.tscn")
const SCN_SHARD = preload("res://Props/SkinShard.tscn")

onready var container: Node2D = $SkinsContainer
onready var drag_x: float = get_global_mouse_position().x
onready var tween: Tween = $Tween
onready var half_screen_width: float = get_viewport_rect().size.x / 2
onready var btnSelect: Button = $btnSelect
onready var btnUnlock: TextureButton = $btnUnlock
onready var shard_container: Node2D = $ShardContainer

var min_x: float = 0
var max_x: float = 0
var cached_nearest_skin_index: int = -1
var active_demo_skin: SkinDemo

func _ready() -> void:
	var current_avatar = GsCustomizationManager.get_avatar_details()

	var index: int = 0
	for key in GsCustomizationManager.AVATARS:
		var node: SkinDemo = SCN_SKIN.instance()
		node.avatar_id = key
		node.avatar = GsCustomizationManager.get_avatar_details(key)
		node.line_length = floor(rand_range(140, 180)) # warning-ignore:narrowing_conversion
		if not node.avatar.get("is_owned"):
			node.modulate = Color(0.4, 0.4, 0.4)
		container.add_child(node)
		node.position = Vector2(
			AVATAR_SPACING * (index - current_avatar.get("index")) + half_screen_width,
			40
		)

		if current_avatar.get("index") == index:
			_update_selected_node(node)

		if index == 0:
			min_x = node.global_position.x
		else:
			max_x = max(max_x, node.global_position.x)

		index += 1

func _process(_delta: float) -> void:
	if Input.is_action_just_pressed("grapple"):
		drag_x = get_global_mouse_position().x
		var __ = tween.stop_all()
	elif Input.is_action_just_released("grapple"):
		_pan_to_nearest_skin()

	if Input.is_action_pressed("grapple"):
		container.global_position.x += get_global_mouse_position().x - drag_x
		drag_x = get_global_mouse_position().x
		_set_nearest_skin()

func create_shards(skin_demo: SkinDemo) -> void:
	var sprite: Sprite = skin_demo.sprite
	var shard_size: Vector2 = sprite.region_rect.size / SHARD_COUNT
	#var collision_size: Vector2 = shard_size / 2 * sprite.scale

	var shard: RigidBody2D
	var shard_sprite: Sprite
	#var shard_collision: CollisionShape2D
	var offset: Vector2

	#shard_container.global_position = sprite.global_position
	#shard_container.global_rotation = sprite.global_rotation
	shard_container.modulate = skin_demo.modulate
	shard_container.global_position = sprite.global_position
	shard_container.global_rotation = sprite.global_rotation

	for _x in SHARD_COUNT:
		for _y in SHARD_COUNT:
			offset = shard_size * Vector2(_x, _y)
			shard = SCN_SHARD.instance()

			shard_sprite = shard.get_node("Sprite")
			shard_sprite.scale = sprite.scale
			if sprite.region_enabled:
				shard_sprite.region_rect = Rect2(sprite.region_rect.position + offset, shard_size)
			else:
				shard_sprite.region_rect = Rect2(offset, shard_size)

			# I don't know why this works. Don't @ me
			shard.position = offset * sprite.scale - sprite.region_rect.size - sprite.region_rect.size / 2

			# Add some random velocity in a random direction
			shard.linear_velocity = Vector2(rand_range(-250, 250), rand_range(-250, 250))
			shard.angular_velocity = rand_range(deg2rad(-90), deg2rad(90))

			shard_container.add_child(shard)

func _set_nearest_skin() -> void:
	var current_x = -container.global_position.x + half_screen_width
	var index: int = round((clamp(current_x, min_x, max_x) - min_x) / AVATAR_SPACING) # warning-ignore:narrowing_conversion

	if index != cached_nearest_skin_index:
		cached_nearest_skin_index = index
		_update_selected_node(container.get_child(index))


# 'Sticks' the camera to the closest skin to the current pan position
func _pan_to_nearest_skin() -> void:
	var __ = tween.interpolate_property(
		container,
		"global_position:x",
		container.global_position.x,
		(active_demo_skin.position.x - half_screen_width) * -1,
		0.1,
		Tween.TRANS_CUBIC
	)
	__ = tween.start()

func _update_selected_node(new_node: SkinDemo):
	if active_demo_skin:
		active_demo_skin.set_avatar_scale(AVATAR_NORMAL_SCALE)

	active_demo_skin = new_node
	active_demo_skin.set_avatar_scale(AVATAR_SELECTED_SCALE)

	btnUnlock.visible = not new_node.avatar.get("is_owned")
	btnSelect.visible = not btnUnlock.visible
	(btnSelect.get_stylebox("normal") as StyleBoxFlat).bg_color = \
		active_demo_skin.avatar.get("color")

	if not new_node.avatar.get("is_owned"):
		(btnUnlock.get_node("Label") as Label).text = \
			"UNLOCK\n" + GsHelpers.format_number(active_demo_skin.avatar.get("price"))


func _on_btnSelect_pressed() -> void:
	GsCustomizationManager.swap_to_avatar(active_demo_skin.avatar_id)
	GsSaveManager.save_game()
	# warning-ignore:return_value_discarded
	get_tree().change_scene("res://UI/MainMenu.tscn")


func _on_btnUnlock_pressed() -> void:
	if GsCustomizationManager.maybe_unlock_avatar(active_demo_skin.avatar_id):
		btnUnlock.visible = false
		btnSelect.visible = true

		create_shards(active_demo_skin)
		active_demo_skin.modulate = Color.white

		GsEvents.emit_signal("coins_spent", active_demo_skin.avatar.get("price"))
	else:
		var animator: AnimationPlayer = $AnimationPlayer
		for _n in 3:
			animator.play("ShakeUnlockButton")
			yield(animator, "animation_finished")


func _on_btnBack_pressed() -> void:
	if get_tree().change_scene("res://UI/MainMenu.tscn") != OK:
		print(self.filename, ": Unable to change scene to MainMenu")
