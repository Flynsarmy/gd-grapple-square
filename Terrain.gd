extends StaticBody2D


# Declare member variables here. Examples:
var obstacle: Resource = preload("res://Obstacle.tscn")
var max_obstacles = 1


# Called when the node enters the scene tree for the first time.
# Inspired by https://www.youtube.com/watch?v=xzj0ech1XWI
func _ready():
	randomize()
	var screen_size: Vector2 = get_viewport_rect().size
	var top_offset: int = $Ceiling.margin_bottom
	var bottom_offset: int = $Floor.margin_top
	
	for i in range(max_obstacles):
		var Obstacle: StaticBody2D = obstacle.instance()
		Obstacle.global_position = self.global_position + Vector2(randi() % int(screen_size.x), top_offset)
		Obstacle.scale = Vector2(rand_range(0.1, 5.0), rand_range(0.1, 5.0))
		$Obstacles.add_child(Obstacle)


# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass
