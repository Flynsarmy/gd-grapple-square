extends Node2D

# Declare member variables here. Examples:
onready var player: RigidBody2D = $Player
onready var camera: Camera2D = $Camera
onready var grapple: DampedSpringJoint2D = $GrappleHook
onready var ray: RayCast2D = $Player/RayCast2D

var score: int
var screen_size: Vector2 # Size of the game window.
var camera_offset: float # How far beside the player will the camera be at all times.
var terrain: Resource = preload("res://Terrain.tscn")
var terrain_placed: bool = false # Whether new world pieces were placed last frame
var old_color: Color = Color(0.949, 0.455, 0.408)

# Called when the node enters the scene tree for the first time.
func _ready():
	screen_size = get_viewport_rect().size
	camera_offset = screen_size.x / 4.0
	grapple.node_a = player.get_path()
	
	# Set the default color of our terrain
	for child in $Terrains.get_children():
		child.set_colors(old_color)
	start_game()
	
func start_game():
	score = 0
	player.start($Position2D.position)
	
func _process(_delta: float):
	ray.look_at(get_global_mouse_position())

	if Input.is_action_just_pressed("grapple"):
		# On Grapple
		if ray.is_colliding():
			grapple.begin_grapple(
				player,
				ray.get_collider(),
				ray.get_collision_point(),
				ray.global_rotation_degrees - 90
			)
			
	# When not grappled
	if Input.is_action_just_released("grapple"):
		grapple.end_grapple()
		
		# Zero the player's vertical movement
		if player.linear_velocity.y < 0:
			player.linear_velocity.y = -200
	
	# Spawn more terrain if we need to
	if int(player.position.x) % int(screen_size.x) < 50:
		if not terrain_placed:
			terrain_placed = true
			var Terrain: StaticBody2D = terrain.instance()
			Terrain.global_position = Vector2(player.global_position.x / screen_size.x * screen_size.x + screen_size.x, 0)
			$Terrains.add_child(Terrain)
			Terrain.set_colors(old_color)
			
			if $Terrains.get_child_count() > 5:
				$Terrains.get_child(0).queue_free()
				
		# TODO: REMOVE THIS. TESTING COLOR TWEENING
#		var new_color = Color(randf(), randf(), randf())
#		for child in $Terrains.get_children():
#			if child.has_method("tween_colors"):
#				child.tween_colors(new_color, 2.0)
#		old_color = new_color
	else:
		terrain_placed = false
		
	# Make the camera follow the players horizontal movement
	camera.position.x = player.position.x + camera_offset
