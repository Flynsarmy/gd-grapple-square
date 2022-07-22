extends Node2D

class_name GSMain

# How fast we want to move the parallax background per second
onready var bg_move_speed: float = get_viewport_rect().size.x / 2

onready var parallax: ParallaxBackground = $GameBackground
onready var CurrentScene: Node = $CurrentScene

func _process(delta: float) -> void:
#	if bg_move_speed > 0:
#		print("moving")
	parallax.scroll_base_offset.x -= bg_move_speed * delta
#	else:
#		print("not moving")

func change_scene(new_scene: String):
	CurrentScene.get_child(0).queue_free()
	CurrentScene.add_child(load(new_scene).instance())
