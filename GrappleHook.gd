extends Node2D

# Grapple inspiration:
# https://www.youtube.com/watch?v=XhaCuXV99ds
# https://www.youtube.com/watch?v=fms3gwZkTLo

export var start_pos: Vector2 = Vector2()
onready var line = $Line
var source: Object
var target_position: Vector2

func _ready() -> void:
	visible = false

func _process(_delta: float):
	if visible:
		# Couldn't figure out how to get this working without zeroing out the rotation/position
		line.global_rotation_degrees = 0
		line.global_position = Vector2.ZERO
		
		# Remove the old grapple line
		line.clear_points()
		
		# Add the new grapple line
		line.add_point(target_position)
		line.add_point(self.global_position, 1)
		
		self.global_position = source.global_position
		self.rest_length = clamp(self.rest_length - 3, 5, self.rest_length)

func begin_grapple(gsource: Object, gtarget: Object, gtarget_position: Vector2, angle: float) -> void:
	source = gsource
	self.global_position = gsource.global_position
#	grapple_target = ray.get_collider()
	target_position = gtarget_position
	var distancelength: float = target_position.distance_to(self.global_position)

	self.length = distancelength
	self.rest_length = distancelength
	self.global_rotation_degrees = angle
	self.node_b = gtarget.get_path()
	
	self.visible = true
	
func end_grapple() -> void:
	self.visible = false
#	grapple_target = null
	self.node_b = self.node_a
