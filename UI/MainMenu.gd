extends Control

onready var player: RigidBody2D = $HideOnPlay/PlayerContainer/Player
onready var wall: StaticBody2D = $HideOnPlay/PlayerContainer/Wall
onready var grapple: Line2D = $HideOnPlay/PlayerContainer/Grapple
onready var parallax: ParallaxBackground = $GameBackground
	
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
	var HideOnPlayContainer: Control = $HideOnPlay
	var SceneTransitionRect: ColorRect = $SceneTransitionRect
	var Animator: AnimationPlayer = $SceneTransitionRect/AnimationPlayer

	# Run the play animation
	HideOnPlayContainer.visible = false
	SceneTransitionRect.visible = true
	Animator.play("MoveToStart")
	yield(Animator, "animation_finished")

	# Save our background
	parallax.get_parent().remove_child(parallax)
	GsGlobals.store("background", parallax)
	
	# Move to the main level
	if get_tree().change_scene("res://Levels/BlockWorld.tscn") != OK:
		print("An unexpected error occured when trying to switch to the Main scene")

func _on_btnExit_pressed() -> void:
	get_tree().quit()

func _on_btnCustomize_pressed() -> void:
	pass
