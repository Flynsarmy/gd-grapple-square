extends Control

# How fast we want to move the parallax background per second
onready var bg_move_speed: Vector2 = get_viewport_rect().size / 2

onready var player: RigidBody2D = $Node2D/Player
onready var wall: StaticBody2D = $Node2D/Wall
onready var grapple: Line2D = $Node2D/Grapple

func _process(delta: float) -> void:
	var parallax: ParallaxBackground = $GameBackground
	parallax.scroll_offset.x -= bg_move_speed.x * delta
	
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
	if get_tree().change_scene("res://Main.tscn") != OK:
		print("An unexpected error occured when trying to switch to the Main scene")


func _on_btnExit_pressed() -> void:
	get_tree().quit()
