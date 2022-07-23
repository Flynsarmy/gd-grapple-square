tool
extends Line2D

class_name GSGrappleHook

signal begin_grapple
signal end_grapple

# Declare member variables here. Examples:
onready var source: Node2D = get_parent()
export(NodePath) var ray_path: NodePath
var ray: RayCast2D
var target_position: Vector2


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	ray = get_node(ray_path)
	pass # Replace with function body.
	

func _get_configuration_warning() -> String:
	var warnings: PoolStringArray = PoolStringArray()

	if not ray_path: 
		warnings.append("%s must have its ray property set for it to function correctly." % name)

	return warnings.join("\n")


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta: float) -> void:
	# Because this is a tool, this function will execute in editor. We don't want that.
	if Engine.editor_hint:
		return

	if Input.is_action_just_pressed("grapple"):
		# On Grapple
		if ray and ray.is_colliding():
			begin_grapple(
				source,
				ray.get_collider(),
				ray.get_collision_point(),
				ray.global_rotation_degrees - 90
		)
			
	# When not grappled
	if Input.is_action_just_released("grapple"):
		end_grapple()
		
	if self.visible:
		# Couldn't figure out how to get this working without zeroing out the rotation/position
		self.global_rotation_degrees = 0
		self.global_position = Vector2.ZERO
		
		# Remove the old grapple line
		self.clear_points()
		
		# Add the new grapple line
		self.add_point(target_position)
		self.add_point(source.global_position, 1)
		
func reset() -> void:
	global_rotation = 0
	visible = false

func begin_grapple(gsource: Object, gtarget: Object, gtarget_position: Vector2, angle: float) -> void:
	emit_signal("begin_grapple", gsource, gtarget, gtarget_position, angle)
	
func end_grapple():
	emit_signal("end_grapple")


func _on_GrappleHook_begin_grapple(_gsource: Object, _gtarget: Object, gtarget_position: Vector2, _angle: float) -> void:
	target_position = gtarget_position
	self.visible = true

func _on_GrappleHook_end_grapple() -> void:
	self.visible = false
