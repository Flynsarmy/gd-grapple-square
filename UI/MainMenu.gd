extends Control

onready var Animator: AnimationPlayer = $SceneTransitionPlayer
onready var player: SkinDemo = $SkinDemo

func _ready() -> void:
	GameBackground.auto_move = true

	var label: Label = $HBoxScores/MarginContainer/VBoxContainer2/lblHighScoreValue
	label.text = GsHelpers.format_number(GsGameState.high_score)

	label = $HBoxScores/MarginContainer/VBoxContainer2/lblYourScoreValue
	label.text = GsHelpers.format_number(GsGameState.score)

	label = $HBoxScores/MarginContainer/VBoxContainer2/lblGamesPlayedValue
	label.text = GsHelpers.format_number(GsGameState.games_played)

	player.sprite.scale = Vector2(0.5, 0.5)
	($btnPlay/ColorRect as ColorRect).color = player.avatar.get("color")
	($PlayGameRect as ColorRect).color = player.avatar.get("color")

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
	if get_tree().change_scene("res://UI/SkinDemos.tscn") != OK:
		print(self.filename, ": Unable to change scene to SkinDemos")
