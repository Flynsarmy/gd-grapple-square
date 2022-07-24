extends Node2D

onready var scn_continue: PackedScene = preload("res://UI/GameContinue.tscn")
onready var player: GSPlayer = $Player
onready var camera: Camera2D = $Camera #GSMain.find_node("Camera")
# How far infront of the player will the camera be at all times.
onready var camera_offset: float = camera.global_position.x - player.global_position.x

export(int) var continues:int = 1    # Number of continues player is allowed on death

var screen_size: Vector2 # Size of the game window.
var default_color: Color = Color("#f27468")

# Called when the node enters the scene tree for the first time.
func _ready():
	screen_size = get_viewport_rect().size

	# Set the default color of our terrain
	var Terrain: GSTerrain = $Terrains/Terrain
	Terrain.set_colors(default_color)
	
func _process(_delta: float):#
	# Switch to MainMenu on escape
	if Input.is_action_just_pressed("menu"):
		if get_tree().change_scene("res://UI/MainMenu.tscn") != OK:
			print(self.filename, ": An unexpected error occured when trying to switch to the MainMenu scene")

	# Make the camera follow the players horizontal movement
	camera.position.x = player.position.x + camera_offset


func _on_Player_player_died(dead_player: GSPlayer) -> void:
	GsGameState.save_game()

	if continues == 0:
		if get_tree().change_scene("res://UI/MainMenu.tscn") != OK:
			print(self.filename, ": An unexpected error occured when trying to switch to the MainMenu scene")
		return
		
	continues -= 1
	
	# Show the Continue popup
	var ContinueScene: GSGameContinue = scn_continue.instance()
	if ContinueScene.connect("continued", self, "_on_GameContinue_continued") != OK:
		print(self.filename, ": Error connecting signal 'continued' of ContinueScene.")
		
	ContinueScene.score = GsGameState.score
	ContinueScene.high_score = GsGameState.high_score

	dead_player.get_parent().add_child(ContinueScene)
	
func _on_GameContinue_continued() -> void:
	player.continue();
