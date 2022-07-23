extends KinematicBody2D

class_name GSPlayer

signal player_died

const GRAVITY: float = 12.0
const MAX_ROTATION_SPEED = 6         # How fast player can rotate when ending grapple
var GRAVITY_DIR: Vector2 = ProjectSettings.get_setting("physics/2d/default_gravity_vector")
var velocity: Vector2 = Vector2.ZERO
var rotation_speed: float = 0        # The amount we rotate depends on how long we held the grapple
onready var ray: RayCast2D = $RayCast2D
onready var ray_default_rotation: float = ray.global_rotation

# Grappling vars
var has_grappled: bool = false       # Whether we've grappled yet this game
var grappling: bool = false          # Whether or not we're currently grappling
var grapple_target_position: Vector2 # Location on terrain we grappled
var grapple_velocity: Vector2        # Velocity we were travelling as the grapple occurred
var grapple_time: float = 0          # How long we were grappling for
var is_in_limbo: bool = false        # When the character dies, wait in limbo for a continue

func _process(delta: float) -> void:
	if is_in_limbo:
		return
	
	if grappling:
		grapple_time += delta

func _physics_process(delta: float) -> void:
	if not has_grappled:
		return
		
	if is_in_limbo:
		return

	if grappling:
		var angle: float = rad2deg(grapple_target_position.angle_to_point(self.global_position)) + 180
		
		var percent: float = (angle - 5.0) * 100.0 / 50.0

		velocity.x = grapple_velocity.x * percent * 0.01
	else:
		velocity += GRAVITY * GRAVITY_DIR * delta
		
		# Horizontal air drag
		velocity.x = max(0, velocity.x - 0.05)
		
	if velocity.x > 7:
		velocity.x = 7
		
	self.rotation_degrees -= rotation_speed
	ray.global_rotation = ray_default_rotation

	var collision: KinematicCollision2D = move_and_collide(velocity)
	if (collision):
		die();
		#velocity -= collision.remainder
		
func continue():
	print("Continuing")
	var screen_size: Vector2 = get_viewport_rect().size
	self.global_position = Vector2(self.global_position.x, screen_size.y / 2)
	self.global_rotation = 0
	self.has_grappled = false
	self.grappling = false
	self.is_in_limbo = false
	ray.global_rotation = self.ray_default_rotation
	
	var grapple: GSGrappleHook = $GrappleHook
	grapple.reset()

func die():
	is_in_limbo = true
	emit_signal("player_died", self)

func _on_GrappleHook_begin_grapple(_gsource: Object, _gtarget: Object, gtarget_position: Vector2, _angle: float) -> void:
	self.grapple_target_position = gtarget_position
	self.velocity.x = max(3.0, self.velocity.x)
	self.velocity.y = -GRAVITY * GRAVITY_DIR.y * 0.5
	self.grapple_velocity = self.velocity
	self.grapple_time = 0
	self.rotation_speed = MAX_ROTATION_SPEED * 0.2
	ray.global_rotation = self.ray_default_rotation
	self.grappling = true
	self.has_grappled = true


func _on_GrappleHook_end_grapple() -> void:
	self.velocity.y = GRAVITY * GRAVITY_DIR.y * 0.01
	
	self.rotation_speed = MAX_ROTATION_SPEED * (1 - min(self.grapple_time, 0.8))
	self.grappling = false


func _on_CollisionDetector_body_entered(_body: Node) -> void:
	pass # Replace with function body.
