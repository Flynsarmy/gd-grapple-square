extends Control

onready var player: RigidBody2D = $PlayerContainer/Player
onready var wall: StaticBody2D = $PlayerContainer/Wall
onready var grapple: Line2D = $PlayerContainer/Grapple

func _ready() -> void:
	var background: GSGameBackground = get_node("/root/GameBackground")
	background.auto_move = true
	
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
	var SceneTransitionRect: ColorRect = $SceneTransitionRect
	var Animator: AnimationPlayer = $SceneTransitionRect/AnimationPlayer

	# Run the play animation
	for node in get_tree().get_nodes_in_group("hide_on_play"):
		node.visible = false
	SceneTransitionRect.visible = true
	Animator.play("MoveToStart", -1, 2.0)
	yield(Animator, "animation_finished")

	# Save our background
	#parallax.get_parent().remove_child(parallax)
	#GsGlobals.store("background", parallax)
	
	# Move to the main level
	if get_tree().change_scene("res://Levels/BlockWorld.tscn") != OK:
		print("An unexpected error occured when trying to switch to the Main scene")

func _on_btnExit_pressed() -> void:
	get_tree().quit()

func _on_btnCustomize_pressed() -> void:
	pass
