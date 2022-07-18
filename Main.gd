extends Node2D

# Declare member variables here. Examples:
onready var player: KinematicBody2D = $Player
onready var camera: Camera2D = $Camera

var screen_size: Vector2 # Size of the game window.
var camera_offset: float # How far beside the player will the camera be at all times.
var default_color: Color = Color(0.949, 0.455, 0.408)

# Called when the node enters the scene tree for the first time.
func _ready():
	screen_size = get_viewport_rect().size
	camera_offset = screen_size.x / 4.0
	
	# Set the default color of our terrain
	$Terrains/Terrain.set_colors(default_color)
		
#	var BGRect: ColorRect = ColorRect.new()
#	BGRect.color = Color(0.588, 0.588, 0.588, 0.392)
#	BGRect.rect_size = Vector2(500, 200)
#	BGRect.set_global_position($Position2D.global_position)
#	$ParallaxBackground/ParallaxLayer2.add_child(BGRect)
		
	start_game()
	
func start_game():
	player.global_position = $Position2D.global_position
	
func _process(_delta: float):#
	# Make the camera follow the players horizontal movement
	camera.position.x = player.position.x + camera_offset
