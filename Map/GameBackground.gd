extends ParallaxBackground

class_name GSGameBackground

# Declare member variables here. Examples:
export(int) var height: int = 480
export(int) var num_blocks: int = 25
export(Vector2) var min_size: Vector2 = Vector2(50, 50)
export(Vector2) var max_size: Vector2 = Vector2(400, 300)
export(bool) var auto_move: bool = false
export(float) var auto_move_speed: float = 360
export(Color) var bg_color: Color = Color("#f4e8d0")
export(Color) var fg_color: Color = Color("#EBDDC6")

onready var BGContainer: ParallaxLayer = $ParallaxLayer2
onready var FGContainer: ParallaxLayer = $ParallaxLayer3

func _ready() -> void:
	randomize()
	var x_pos: float = 0
	var max_x: float = 0
	var rect: ColorRect
	
	# Background blocks
	for _n in num_blocks:
		rect = spawn_top_block(Vector2(rand_range(x_pos-20, x_pos+200), 0), bg_color)
		x_pos = rect.get_position().x + rect.get_size().x
		BGContainer.add_child(rect)
		
	max_x = x_pos
	x_pos = 0
	
	for _n in num_blocks:
		rect = spawn_bottom_block(Vector2(rand_range(x_pos-20, x_pos+200), 0), bg_color)
		x_pos = rect.get_position().x + rect.get_size().x
		BGContainer.add_child(rect)
		
	var parallax_layer: ParallaxLayer = $ParallaxLayer2
	parallax_layer.motion_mirroring.x = max(max_x, x_pos)
	
	x_pos = 0
	max_x = 0
	
	# Foreground blocks
	for _n in num_blocks:
		rect = spawn_top_block(Vector2(rand_range(x_pos-20, x_pos+200), 0), fg_color)
		x_pos = rect.get_position().x + rect.get_size().x
		FGContainer.add_child(rect)
		
	max_x = x_pos
	x_pos = 0
	
	for _n in num_blocks:
		rect = spawn_bottom_block(Vector2(rand_range(x_pos-20, x_pos+200), 0), fg_color)
		x_pos = rect.get_position().x + rect.get_size().x
		FGContainer.add_child(rect)
		
	parallax_layer = $ParallaxLayer3
	parallax_layer.motion_mirroring.x = max(max_x, x_pos)
	
func _process(delta: float) -> void:
	if auto_move:
		self.scroll_base_offset.x -= auto_move_speed * delta
		
func spawn_block(position: Vector2, color: Color) -> ColorRect:
	var rect = ColorRect.new()
	var size = Vector2(
		rand_range(min_size.x, max_size.x),
		rand_range(min_size.y, max_size.y)
	)
	rect.set_size(size)
	rect.set_position(position)
	rect.color = color
	
	return rect
		
func spawn_top_block(position: Vector2, color: Color) -> ColorRect:
	var rect = spawn_block(position, color)

	return rect
	
func spawn_bottom_block(position: Vector2, color: Color) -> ColorRect:
	var rect = spawn_block(position, color)
	rect.set_position(Vector2(rect.rect_position.x, height - rect.rect_size.y))
	
	return rect
