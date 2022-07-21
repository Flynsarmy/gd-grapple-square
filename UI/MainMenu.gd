extends Control

# How fast we want to move the parallax background per second
onready var bg_move_speed: Vector2 = get_viewport_rect().size / 2

func _process(delta: float) -> void:
	var parallax: ParallaxBackground = $GameBackground
	parallax.scroll_offset.x -= bg_move_speed.x * delta

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
