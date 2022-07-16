extends StaticBody2D


# Declare member variables here. Examples:
onready var Obstacles: Node = $Obstacles
var res_obstacle: Resource = preload("res://Obstacle.tscn")
var max_obstacles: int = 6
var min_scale_w: float = 1
var max_scale_w: float = 3
var min_scale_h: float = 0.3
var max_scale_h: float = 0.8


# Called when the node enters the scene tree for the first time.
# Inspired by https://www.youtube.com/watch?v=xzj0ech1XWI
func _ready():
	randomize()
	var screen_size: Vector2 = get_viewport_rect().size
	var top_offset: int = $Ceiling.margin_bottom
	var bottom_offset: int = $Floor.margin_top
	
	# Top small terrain
	for _i in range(max_obstacles):
		var Obstacle: StaticBody2D = create_obstacle(min_scale_w, max_scale_w, min_scale_h, max_scale_h)
		Obstacle.global_position = self.global_position + Vector2(randi() % int(screen_size.x), top_offset)
		
		
	# Bottom small terrain
	for _i in range(max_obstacles):
		var Obstacle: StaticBody2D = create_obstacle(min_scale_w, max_scale_w, min_scale_h, max_scale_h)
		# Don't know how to grab the Obstacle.ColorRect's base height, so hardcode it for now
		Obstacle.global_position = \
			self.global_position + \
			Vector2(randi() % int(screen_size.x), bottom_offset) - \
			Vector2(0, 40.0 * Obstacle.scale.y)
		
	# Top big terrain
#	if randi() % 4 == 0:
#		var Obstacle: StaticBody2D = create_obstacle(3.0, 5.0, 3.0, 5.0)
#		Obstacle.global_position = self.global_position + Vector2(randi() % int(screen_size.x), top_offset)
#
#	# Bottom big terrain
#	else:
#		if randi() % 4 == 0:
#			var Obstacle: StaticBody2D = create_obstacle(3.0, 5.0, 3.0, 5.0)
#			# Don't know how to grab the Obstacle.ColorRect's base height, so hardcode it for now
#			Obstacle.global_position = \
#				self.global_position + \
#				Vector2(randi() % int(screen_size.x), bottom_offset) - \
#				Vector2(0, 40.0 * Obstacle.scale.y)
			
# Create a new piece of terrain and add it to the Obstacles container
func create_obstacle(local_min_scale_w: float, local_max_scale_w: float, local_min_scale_h: float, local_max_scale_h: float) -> StaticBody2D:
	var Obstacle: StaticBody2D = res_obstacle.instance()
	Obstacle.scale = Vector2(rand_range(local_min_scale_w, local_max_scale_w), rand_range(local_min_scale_h, local_max_scale_h))
	Obstacles.add_child(Obstacle)
	return Obstacle
	
func set_colors(new_color: Color) -> void:
	$Ceiling.modulate = new_color
	$Floor.modulate = new_color
	# Obstacles
	for obstacle in $Obstacles.get_children():
		obstacle.get_node("ColorRect").modulate = new_color
	
func tween_colors(new_color: Color, duration: float) -> void:
	# Floor and ceiling
	$Tween.interpolate_property($Ceiling, "modulate", $Ceiling.modulate, new_color, duration, Tween.TRANS_LINEAR)
	$Tween.interpolate_property($Floor, "modulate", $Floor.modulate, new_color, duration, Tween.TRANS_LINEAR)
	# Obstacles
	for obstacle in $Obstacles.get_children():
		var block: ColorRect = obstacle.get_node("ColorRect")
		$Tween.interpolate_property(block, "modulate", block.modulate, new_color, duration, Tween.TRANS_LINEAR)
	$Tween.start()
