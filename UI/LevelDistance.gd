extends Node2D

class_name GSLevelDistance

export(int) var number: int = 1

onready var lblNumber: Label = $lblNumber

var width: float = 0

func _ready() -> void:
	lblNumber.text = str(number)
	
	var notifier: VisibilityNotifier2D = $VisibilityNotifier2D
	width = notifier.rect.size.x * notifier.scale.x

func _on_VisibilityNotifier2D_screen_entered() -> void:
	# warning-ignore:unsafe_method_access
	var new_node: GSLevelDistance = load(self.filename).instance()
	var new_position: Vector2 = self.global_position
	new_position.x += width

	new_node.number = self.number + 1
	new_node.transform = Transform2D(self.global_rotation, new_position)
	get_parent().add_child(new_node)


func _on_VisibilityNotifier2D_screen_exited() -> void:
	queue_free()

# The only body we collide with is the Player so no need to check
func _on_PlayerCollider_body_entered(_body: Node) -> void:
	lblNumber.add_color_override("font_color", Color("f27468"))
