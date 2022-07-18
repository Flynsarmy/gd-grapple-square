extends StaticBody2D


# Declare member variables here. Examples:
onready var Obstacles: Node = $Obstacles
var res_obstacle: Resource = preload("res://Obstacle.tscn")
var max_obstacles: int = 6               # Num of terrain pieces to spawn on top and on bottom
var min_scale: Vector2 = Vector2(1, 0.3) # Min scale of normal-sized terrain
var max_scale: Vector2 = Vector2(3, 0.8) # Max scale of normal-sized terrain


# Called when the node enters the scene tree for the first time.
func _ready():
	randomize()
	var screen_size: Vector2 = get_viewport_rect().size
	var top_offset: int = $Ceiling.margin_bottom
	var bottom_offset: int = $Floor.margin_top
	
	# Top small terrain
	for _i in range(max_obstacles):
		var Obstacle: StaticBody2D = create_obstacle(min_scale, max_scale)
		Obstacle.global_position = self.global_position + Vector2(randi() % int(screen_size.x), top_offset)
		
		
	# Bottom small terrain
	for _i in range(max_obstacles):
		var Obstacle: StaticBody2D = create_obstacle(min_scale, max_scale)
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
func create_obstacle(the_min_scale: Vector2, the_max_scale: Vector2) -> StaticBody2D:
	var Obstacle: StaticBody2D = res_obstacle.instance()
	Obstacle.scale = Vector2(
		rand_range(the_min_scale.x, the_max_scale.x),
		rand_range(the_min_scale.y, the_max_scale.y)
	)
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

# Spawn a new instance of this piece of terrain to the right of it as it enters the screen
func _on_VisibilityNotifier2D_screen_entered() -> void:
	#Spawn a copy of myself to the right
	var new_node: StaticBody2D = load(self.filename).instance()
	var new_position: Vector2 = self.global_position
	new_position.x += $Ceiling.margin_right - $Ceiling.margin_left

	new_node.transform = Transform2D(self.global_rotation, new_position)
	get_parent().add_child(new_node)
	new_node.set_colors($Ceiling.modulate)

# Despawn terrain as it leaves the left side of screen
func _on_VisibilityNotifier2D_screen_exited() -> void:
	queue_free()
