extends RigidBody2D

# Define a custom signal called "hit" that we will have our player emit when it collides with an enemy.
signal hit


# Declare member variables here. Examples:
var screen_size: Vector2 # Size of the game window.


# Called when the node enters the scene tree for the first time.
func _ready():
	screen_size = get_viewport_rect().size
	# self.gravity_scale = 0
	
	hide()
	
#func _input(event: InputEvent):
#	if event.is_action_pressed("grapple"):
#		$Chain.shoot(Vector2(1, -1))
#	elif event.is_action_released("grapple"):
#		$Chain.release()
#	pass
	
# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float):
	# $Chain.global_rotation = 0
	pass

func start(pos: Vector2):
	self.position = pos
	self.show()
	# $CollisionShape2D.disabled = false


func _on_Player_body_entered(body):
	self.hide()  # Player disappears after being hit.
	self.emit_signal("hit")
	# Must be adeferred as we can't change physics properties on a physics callback.
	# $CollisionShape2D.set_deferred("disabled", true)
	print("Test")
	
	
