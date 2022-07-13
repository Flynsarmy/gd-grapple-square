extends Line2D

export var start_pos: Vector2 = Vector2()
export var end_pos: Vector2 = Vector2()

func _process(delta: float):
	if self.visible:
		add_point(start_pos)
		add_point(end_pos, 1)
		remove_point(0)
	else:
		clear_points()
