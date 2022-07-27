extends Node2D

class_name UnlockableAvatar

export(String) var avatar: String = "default"

onready var player: RigidBody2D = $Player
onready var wall: StaticBody2D = $Wall
onready var grapple: Line2D = $Wall/Grapple
onready var joint: PinJoint2D = $Wall/PinJoint2D

func _ready() -> void:
	randomize()
	# Update the avatar
	var details: Dictionary = GsCustomizationManager.get_avatar_details(avatar)
	($Player/Sprite as Sprite).region_rect.position = details.get("offset")
	grapple.default_color = details.get("color")

	# Move to a random point along the grapple
	#print(joint.global_position, ", ", player.global_position)
	print(
		joint.global_position.distance_to(player.global_position),
		" ",
		rad2deg(player.global_position.angle_to_point(joint.global_position))
	)
#	var joint_offset = joint.global_position.x - player.global_position.x
#	player.position.x += rand_range(-joint_offset, joint_offset)

	# Make the grapple work
	player.look_at(joint.global_position)
	player.rotate(deg2rad(90))
	joint.node_b = player.get_path()


func _physics_process(_delta: float) -> void:
	grapple.clear_points()
	grapple.add_point(player.position)
	grapple.add_point(wall.position, 1)
