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

	if GsEvents.connect("avatar_changed", self, "_on_avatar_changed") != OK:
		print(self.filename, ": Unable to connect to the avatar_changed signal")

	_on_avatar_changed(GsCustomizationManager.get_avatar_details())

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
	Animator.play("OnPlay", -1, 2.0)
	yield(Animator, "animation_finished")

	GsEvents.emit_signal("started_new_game")

	# Move to the main level
	if get_tree().change_scene("res://Levels/BlockWorld.tscn") != OK:
		print(self.filename, ": An unexpected error occured when trying to switch to the Main scene")

func _on_btnExit_pressed() -> void:
	get_tree().quit()

func _on_btnCustomize_pressed() -> void:
	Animator.play_backwards("OnLoad")
	yield(Animator, "animation_finished")
	Animator.play("HideMainPlayer", -1, 3)
	yield(Animator, "animation_finished")

func _on_avatar_changed(new_avatar: Dictionary) -> void:
	# Update the player sprite
	($PlayerContainer/Player/Sprite as Sprite).region_rect.position = new_avatar.get("offset")
	# And their grapple hook
	($PlayerContainer/Grapple as Line2D).default_color = new_avatar.color
	# Set the play button's background color
	($btnPlay/ColorRect as ColorRect).color = new_avatar.get("color")
	# Set the transition animation's color
	($PlayGameRect as ColorRect).color = new_avatar.get("color")
