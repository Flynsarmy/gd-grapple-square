extends Control

const AVATAR_SPACING = 200
const AVATAR_NORMAL_SCALE = 1
const AVATAR_SELECTED_SCALE = 3
const SCN_SKIN = preload("res://UI/SwingingSquare.tscn")

onready var container: Node2D = $AvatarsContainer
onready var drag_x: float = get_global_mouse_position().x
onready var tween: Tween = $Tween
onready var half_screen_width: float = get_viewport_rect().size.x / 2

var min_x: float = 0
var max_x: float = 0
var cached_nearest_skin_index: int = -1
var selected_skin_node: SwingingSquare

func _ready() -> void:
	var current_avatar = GsCustomizationManager.get_avatar_details()

	var index: int = 0
	for key in GsCustomizationManager.AVATARS:
		var node: SwingingSquare = SCN_SKIN.instance()
		node.avatar = GsCustomizationManager.get_avatar_details(key)
		node.max_swing_angle = deg2rad(15)
		node.line_length = floor(rand_range(180, 220)) # warning-ignore:narrowing_conversion
		node.swing_duration = 1.2
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
		(selected_skin_node.position.x - half_screen_width) * -1,
		0.1,
		Tween.TRANS_CUBIC
	)
	__ = tween.start()

func _update_selected_node(new_node: SwingingSquare):
	if selected_skin_node:
		selected_skin_node.set_avatar_scale(AVATAR_NORMAL_SCALE)

	selected_skin_node = new_node
	selected_skin_node.set_avatar_scale(AVATAR_SELECTED_SCALE)
