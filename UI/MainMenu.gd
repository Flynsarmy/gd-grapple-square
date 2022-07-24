extends Control

onready var player: RigidBody2D = $PlayerContainer/Player
onready var wall: StaticBody2D = $PlayerContainer/Wall
onready var grapple: Line2D = $PlayerContainer/Grapple
onready var Animator: AnimationPlayer = $SceneTransitionPlayer

func _ready() -> void:
	GameBackground.auto_move = true
	
	var label: Label = $HBoxScores/MarginContainer/VBoxContainer2/lblHighScoreValue
	label.text = GsHelpers.format_number(GsGameState.high_score)
	
	label = $HBoxScores/MarginContainer/VBoxContainer2/lblYourScoreValue
	label.text = GsHelpers.format_number(GsGameState.score)
	
	label = $HBoxScores/MarginContainer/VBoxContainer2/lblGamesPlayedValue
	label.text = GsHelpers.format_number(GsGameState.games_played)
	
	GsGameState.save_game()
	
func _physics_process(_delta: float) -> void:
	grapple.clear_points()
	grapple.add_point(player.global_position)
	grapple.add_point(wall.global_position, 1)

func _on_btnSound_toggled(button_pressed: bool) -> void:
	if button_pressed:
		print("Muted!")
	else:
		print("Unmuted!")


func _on_btnPlay_pressed() -> void:
	Animator.play("MoveToStart", -1, 2.0)
	yield(Animator, "animation_finished")

	GsEvents.emit_signal("started_new_game")
	
	# Move to the main level
	if get_tree().change_scene("res://Levels/BlockWorld.tscn") != OK:
		print(self.filename, ": An unexpected error occured when trying to switch to the Main scene")

func _on_btnExit_pressed() -> void:
	get_tree().quit()

func _on_btnCustomize_pressed() -> void:
	pass
