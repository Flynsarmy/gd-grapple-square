extends Node2D

class_name SkinDemo

# Half the swing arc in radians
export(float) var max_swing_angle: float = deg2rad(15)
export(float) var swing_duration: float = 1.2
export(int) var line_length: int = 160
export(String) var avatar_id: String = "" # warning-ignore:unused_class_variable
export(Dictionary) var avatar: Dictionary = {}

onready var source: Position2D = $SourcePosition
onready var player: Node2D = $SourcePosition/Player
onready var grapple: Line2D = $SourcePosition/GrappleLine
onready var swing_tween: Tween = $SwingTween
# The sprite is manipulated by parent classes
onready var sprite: Sprite = $SourcePosition/Player/Sprite # warning-ignore:unused_class_variable

func _ready() -> void:
	randomize()

	if not avatar.has("offset"):
		avatar = GsCustomizationManager.get_avatar_details()

	# Move player into position
	player.position.x -= line_length
	($SourcePosition/Player/Sprite as Sprite).region_rect.position = avatar.get("offset")
	# Set up the grapple line
	grapple.default_color = avatar.get("color")
	grapple.add_point(source.position)
	grapple.add_point(player.position)

	var start_angle_offset: float = rand_range(-max_swing_angle, max_swing_angle)
	var percent_through_swing = (max_swing_angle - start_angle_offset) / (max_swing_angle * 2)
	source.global_rotation = deg2rad(-90) + start_angle_offset

	# The first swing will be offset by a random amount requiring this custom tween
	var __ = swing_tween.interpolate_property(
		source,
		"global_rotation",
		source.global_rotation,
		deg2rad(-90) - max_swing_angle,
		swing_duration,
		Tween.TRANS_SINE
	)
	__ = swing_tween.start()
	# Seek to the amount we started through the swing so the animation plays at the correct speed.
	__ = swing_tween.seek(swing_duration * percent_through_swing)

	yield(swing_tween, "tween_completed")
	swing(false)


func swing(is_swinging_forwards: bool) -> void:
	var start_angle: float = deg2rad(-90) + (max_swing_angle if is_swinging_forwards else -max_swing_angle)
	var end_angle: float = deg2rad(-90) + (-max_swing_angle if is_swinging_forwards else max_swing_angle)

	var __ = swing_tween.interpolate_property(
		source,
		"global_rotation",
		start_angle,
		end_angle,
		swing_duration,
		Tween.TRANS_SINE
	)
	__ = swing_tween.start()

	yield(swing_tween, "tween_completed")
	swing(!is_swinging_forwards)

func set_avatar_scale(new_scale: float) -> void:
	var scale_tween: Tween = $ScaleTween

	var __ = scale_tween.interpolate_property(
		sprite,
		"scale",
		sprite.scale,
		Vector2(new_scale, new_scale),
		0.1
	)
	__ = scale_tween.start()
