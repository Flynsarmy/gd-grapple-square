extends Node2D

# Grapple inspiration:
# https://www.youtube.com/watch?v=XhaCuXV99ds
# https://www.youtube.com/watch?v=fms3gwZkTLo

# Declare member variables here. Examples:
# var a = 2
# var b = "text"
onready var player: RigidBody2D = $Player
onready var camera: Camera2D = $Camera
onready var grapple: DampedSpringJoint2D = $Grapple
onready var ray: RayCast2D = $Player/RayCast2D
onready var grapple_line: Line2D = $GrappleLine

var score: int
var screen_size: Vector2 # Size of the game window.
var camera_offset: int # How far beside the player will the camera be at all times.
var grapple_target: Object = null # The object our grapple hit when we fired it out.
var grapple_target_position: Vector2 = Vector2(0, 0)
var terrain: Resource = preload("res://Terrain.tscn")
var terrain_placed: bool = false # Whether new world pieces were placed last frame

# Called when the node enters the scene tree for the first time.
func _ready():
	screen_size = get_viewport_rect().size
	camera_offset = screen_size.x / 4
	start_game()
	
func start_game():
	score = 0
	player.start($Position2D.position)
	
func _process(delta: float):
	if grapple_target:
		grapple_line.start_pos = grapple_target_position

	ray.look_at(get_global_mouse_position())

	if Input.is_action_just_pressed("grapple"):
		# On Grapple
		if ray.is_colliding():
			grapple.global_position = player.global_position
			grapple_target = ray.get_collider()
			grapple_target_position = ray.get_collision_point()
			var distancelength: float = grapple_target_position.distance_to(grapple.global_position)

			grapple.length = distancelength
			grapple.global_rotation_degrees = ray.global_rotation_degrees - 90
			grapple.rest_length = distancelength# * 0.75

			grapple.node_b = grapple_target.get_path()
			
	# On grapple swing
	if Input.is_action_pressed("grapple"):
		grapple.global_position = player.global_position
		grapple_line.visible = true
		grapple_line.end_pos = player.global_position
		grapple.rest_length = clamp(grapple.rest_length - 3, 5, grapple.rest_length)

	# When not grappled
	if Input.is_action_just_released("grapple"):
		grapple_line.visible = false
		grapple_target = null
		grapple.node_b = grapple.node_a
		
		# Zero the player's vertical movement
		if player.linear_velocity.y < 0:
			player.linear_velocity.y = -200
	
	# Spawn more terrain if we need to
	if int(player.position.x) % int(screen_size.x) < 50:
		if not terrain_placed:
			terrain_placed = true
			var Terrain: StaticBody2D = terrain.instance()
			Terrain.global_position = Vector2(int(player.global_position.x) / int(screen_size.x) * int(screen_size.x) + screen_size.x, 0)
			print("Adding terrain at ", Terrain.global_position)
			$Terrains.add_child(Terrain)
			
			if $Terrains.get_child_count() > 5:
				$Terrains.get_child(0).queue_free()
				print("Removing old scene")
	else:
		terrain_placed = false
		
	# Make the camera follow the players horizontal movement
	camera.position.x = player.position.x + camera_offset
