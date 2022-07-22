extends Node2D

# Declare member variables here. Examples:
onready var GSMain: GSMain = get_tree().current_scene
onready var player: KinematicBody2D = $Player
onready var camera: Camera2D = GSMain.find_node("Camera")
# How far beside the player will the camera be at all times.
onready var camera_offset: float = camera.global_position.x - player.global_position.x
onready var background: ParallaxBackground = GSMain.find_node("GameBackground")

var screen_size: Vector2 # Size of the game window.
var default_color: Color = Color("#f27468")

# Called when the node enters the scene tree for the first time.
func _ready():
	
	screen_size = get_viewport_rect().size

	# Set the default color of our terrain
	var Terrain: GSTerrain = $Terrains/Terrain
	Terrain.set_colors(default_color)
	
	print(camera.global_position, " ", player.global_position)
	
func _process(_delta: float):#
	# Switch to MainMenu on escape
	if Input.is_action_just_pressed("menu"):
		get_tree().current_scene.change_scene("res://UI/MainMenu.tscn")
#		if get_tree().change_scene("res://UI/MainMenu.tscn") != OK:
#			print("An unexpected error occured when trying to switch to the MainMenu scene")

	# Make the camera follow the players horizontal movement
	
#	var current_offset: float = background.base_offset.x
#	print("Before: ", current_offset)
	camera.position.x = player.position.x + camera_offset
#	background.scroll_offset.x = current_offset
#	print("After: ", current_offset)
