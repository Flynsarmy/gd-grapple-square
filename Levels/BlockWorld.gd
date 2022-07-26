extends Node2D

onready var scn_continue: PackedScene = preload("res://UI/GameContinue.tscn")
onready var player: GSPlayer = $Player
onready var camera: Camera2D = $Camera #GSMain.find_node("Camera")
onready var terrains: Node2D = $Terrains
# How far infront of the player will the camera be at all times.
onready var camera_offset: float = camera.global_position.x - player.global_position.x

export(int) var continues:int = 1    # Number of continues player is allowed on death

var screen_size: Vector2 # Size of the game window.
# Starting at a distance of 5, we'll tween to these colours in order every 5
var colors = ["F27468", "67A7C1", "B175C9", "77C47C", "494949", "C79152", "9FB9AE", "B9B653"]

# Called when the node enters the scene tree for the first time.
func _ready():
	screen_size = get_viewport_rect().size
	if GsEvents.connect("distance_marker_reached", self, "_on_distance_marker_reached") != OK:
		print(self.filename, ": Unable to connect to the distance_marker_reached signal")
	
func _process(_delta: float):#
	# Switch to MainMenu on escape
	if Input.is_action_just_pressed("menu"):
		if get_tree().change_scene("res://UI/MainMenu.tscn") != OK:
			print(self.filename, ": An unexpected error occured when trying to switch to the MainMenu scene")

	# Make the camera follow the players horizontal movement
	camera.position.x = player.position.x + camera_offset


func _on_Player_player_died(dead_player: GSPlayer) -> void:
	GsGameState.save_game()
	
	# Don't display continue modal if we can't afford it
	if GsGameState.coins < GsGameState.continue_cost:
		continues = 0

	if continues == 0:
		_on_GameContinue_not_continued()
		return
		
	continues -= 1
	
	# Show the Continue popup
	var ContinueScene: GSGameContinue = scn_continue.instance()
	if ContinueScene.connect("continued", self, "_on_GameContinue_continued") != OK:
		print(self.filename, ": Error connecting signal 'continued' of ContinueScene.")
	if ContinueScene.connect("not_continued", self, "_on_GameContinue_not_continued") != OK:
		print(self.filename, ": Error connecting signal 'not_continued' of ContinueScene.")

	# Display the Continue modal
	dead_player.get_parent().add_child(ContinueScene)
	
func _on_GameContinue_continued() -> void:
	player.continue();
	
func _on_GameContinue_not_continued() -> void:
	# Play teh transition animation
	var animator: AnimationPlayer = $Camera/TransitionContainer/TransitionAnimator
	animator.play("BackToMenu")
	yield(animator, "animation_finished")
	
	# Change to mainmenu scene
	if get_tree().change_scene("res://UI/MainMenu.tscn") != OK:
		print(self.filename, ": An unexpected error occured when trying to switch to the MainMenu scene")

func _on_distance_marker_reached(number: int) -> void:
	if number % 5 == 0:
		var max_color = colors.size() - 1
		var new_color = colors[min(number / 5, max_color)] # warning-ignore:integer_division
		
		# Tween our terrains color
		var tween: Tween = $Tween
		if tween.interpolate_property(terrains, "modulate", terrains.modulate, Color(new_color), 1):
			var __ = tween.start()
		
		# Update the distance markers color
		for node in $DistanceNumbers.get_children():
			if node is GSLevelDistance:
				node.reached_color = new_color

		# Update the BackToMenu transition container's colour too
		($TransitionContainer as Node2D).modulate = new_color
