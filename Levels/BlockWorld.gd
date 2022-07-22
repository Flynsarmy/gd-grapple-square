extends Node2D

# Declare member variables here. Examples:
onready var player: KinematicBody2D = $Player
onready var camera: Camera2D = $Camera #GSMain.find_node("Camera")
# How far beside the player will the camera be at all times.
onready var camera_offset: float = camera.global_position.x - player.global_position.x

var background: GSGameBackground

var screen_size: Vector2 # Size of the game window.
var default_color: Color = Color("#f27468")

# Called when the node enters the scene tree for the first time.
func _ready():
	
	screen_size = get_viewport_rect().size

	# Set the default color of our terrain
	var Terrain: GSTerrain = $Terrains/Terrain
	Terrain.set_colors(default_color)
	
	background = GsGlobals.getStored("background")
	$Terrains.get_parent().add_child(background)
	
func _process(_delta: float):#
	# Switch to MainMenu on escape
	if Input.is_action_just_pressed("menu"):
		if get_tree().change_scene("res://UI/MainMenu.tscn") != OK:
			print("An unexpected error occured when trying to switch to the MainMenu scene")

	# Make the camera follow the players horizontal movement
	camera.position.x = player.position.x + camera_offset
