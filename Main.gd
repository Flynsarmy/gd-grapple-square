extends Node2D

# Grapple inspiration:
# https://www.youtube.com/watch?v=XhaCuXV99ds
# https://www.youtube.com/watch?v=fms3gwZkTLo

var score


# Declare member variables here. Examples:
# var a = 2
# var b = "text"
onready var player = $Player
onready var grapple: DampedSpringJoint2D = $Grapple
onready var ray = $Player/RayCast2D
onready var grapple_line = $GrappleLine

var grapple_target: Object = null
var grapple_target_position: Vector2 = Vector2(0, 0)

# Called when the node enters the scene tree for the first time.
func _ready():
	start_game()
	
func start_game():
	score = 0
	$Player.start($Position2D.position)
	
func _process(delta: float):
	if grapple_target:
		grapple_line.start_pos = grapple_target_position
	
	grapple.global_position = player.global_position
	ray.look_at(get_global_mouse_position())
	
	if Input.is_action_just_pressed("grapple"):
		# On Grapple
		if ray.is_colliding():
			grapple_target = ray.get_collider()
			grapple_target_position = ray.get_collision_point()
			var distancelength: float = grapple_target_position.distance_to(player.global_position)

			grapple.length = distancelength
			grapple.global_rotation_degrees = ray.global_rotation_degrees - 90
			grapple.rest_length = distancelength * 0.75

			grapple.node_b = grapple_target.get_path()
			player.gravity_scale = 1
			
	if Input.is_action_pressed("grapple"):
		grapple_line.visible = true
		grapple_line.end_pos = player.global_position
		grapple.rest_length = clamp(grapple.rest_length - 1, 5, grapple.rest_length)

	if not Input.is_action_pressed("grapple"):
		grapple_line.visible = false
		grapple_target = null
		grapple.node_b = grapple.node_a
		player.gravity_scale = 5
