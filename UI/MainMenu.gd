extends Control

# How fast we want to move the parallax background per second
#onready var bg_move_speed: Vector2 = get_viewport_rect().size / 2

onready var player: RigidBody2D = $HideOnPlay/PlayerContainer/Player
onready var wall: StaticBody2D = $HideOnPlay/PlayerContainer/Wall
onready var grapple: Line2D = $HideOnPlay/PlayerContainer/Grapple
#onready var parallax: ParallaxBackground = $GameBackground

func _process(delta: float) -> void:
#	if parallax:
#		parallax.scroll_offset.x -= bg_move_speed.x * delta
	pass
	
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
	$HideOnPlay.visible = false
	$SceneTransitionRect.visible = true
	$SceneTransitionRect/AnimationPlayer.play("MoveToStart")
	yield($SceneTransitionRect/AnimationPlayer, "animation_finished")
#	var background: Node = $GameBackground
#	background.get_parent().remove_child(background)
#	GsGlobalState.store("background", background)
#	if get_tree().change_scene("res://Main.tscn") != OK:
#		print("An unexpected error occured when trying to switch to the Main scene")
#	get_tree().change_scene("res://Levels/BlockWorld.tscn")
	get_tree().current_scene.change_scene("res://Levels/BlockWorld.tscn")


func _on_btnExit_pressed() -> void:
	get_tree().quit()


func _on_btnCustomize_pressed() -> void:
	print("Before ", get_tree().current_scene.find_node("GameBackground").scroll_offset)
	get_tree().current_scene.find_node("Camera").global_position.x = 0
	print("After ", get_tree().current_scene.find_node("GameBackground").scroll_offset)
