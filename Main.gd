extends Node2D

# Declare member variables here. Examples:
onready var player: KinematicBody2D = $Player
onready var camera: Camera2D = $Camera
onready var grapple: DampedSpringJoint2D = $GrappleHook
onready var ray: RayCast2D = player.get_node("RayCast2D")

var screen_size: Vector2 # Size of the game window.
var camera_offset: float # How far beside the player will the camera be at all times.
var terrain: Resource = preload("res://Terrain.tscn")
var terrain_placed: bool = false # Whether new world pieces were placed last frame
var old_color: Color = Color(0.949, 0.455, 0.408)

# Grapple
export var start_pos: Vector2 = Vector2()
onready var grapple_line: Line2D = $GrappleLine
var source: Object
var target_position: Vector2

signal begin_grapple
signal end_grapple

# Called when the node enters the scene tree for the first time.
func _ready():
	screen_size = get_viewport_rect().size
	camera_offset = screen_size.x / 4.0
	
	# Set the default color of our terrain
	for child in $Terrains.get_children():
		child.set_colors(old_color)
		
#	var BGRect: ColorRect = ColorRect.new()
#	BGRect.color = Color(0.588, 0.588, 0.588, 0.392)
#	BGRect.rect_size = Vector2(500, 200)
#	BGRect.set_global_position($Position2D.global_position)
#	$ParallaxBackground/ParallaxLayer2.add_child(BGRect)
		
	start_game()
	
func start_game():
	player.global_position = $Position2D.global_position
	
func _process(_delta: float):
	if Input.is_action_just_pressed("grapple"):
		# On Grapple
		if ray.is_colliding():
			begin_grapple(
				player,
				ray.get_collider(),
				ray.get_collision_point(),
				ray.global_rotation_degrees - 90
			)
			
	# When not grappled
	if Input.is_action_just_released("grapple"):
		end_grapple()
		
	if grapple_line.visible:
		# Couldn't figure out how to get this working without zeroing out the rotation/position
		grapple_line.global_rotation_degrees = 0
		grapple_line.global_position = Vector2.ZERO
		
		# Remove the old grapple line
		grapple_line.clear_points()
		
		# Add the new grapple line
		grapple_line.add_point(target_position)
		grapple_line.add_point(source.global_position, 1)
	
	# Spawn more terrain if we need to
	if int(player.position.x) % int(screen_size.x) < 50:
		if not terrain_placed:
			spawn_terrain()
	else:
		terrain_placed = false
		
	# Make the camera follow the players horizontal movement
	camera.position.x = player.position.x + camera_offset

func begin_grapple(gsource: Object, gtarget: Object, gtarget_position: Vector2, angle: float) -> void:
	emit_signal("begin_grapple", gsource, gtarget, gtarget_position, angle)
	
func end_grapple():
	emit_signal("end_grapple")

func spawn_terrain():
	terrain_placed = true
	var Terrain: StaticBody2D = terrain.instance()
	Terrain.global_position = Vector2(player.global_position.x / screen_size.x * screen_size.x + screen_size.x, 0)
	$Terrains.add_child(Terrain)
	Terrain.set_colors(old_color)
	
	if $Terrains.get_child_count() > 5:
		$Terrains.get_child(0).queue_free()
		
	# TODO: REMOVE THIS. TESTING COLOR TWEENING
#	var new_color = Color(randf(), randf(), randf())
#	for child in $Terrains.get_children():
#		if child.has_method("tween_colors"):
#			child.tween_colors(new_color, 2.0)
#	old_color = new_color


func _on_Main_begin_grapple(gsource: Object, gtarget: Object, gtarget_position: Vector2, angle: float) -> void:
	source = gsource # Player
	target_position = gtarget_position
	grapple_line.visible = true

func _on_Main_end_grapple() -> void:
	grapple_line.visible = false
