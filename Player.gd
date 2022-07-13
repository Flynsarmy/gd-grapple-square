extends RigidBody2D

# Define a custom signal called "hit" that we will have our player emit when it collides with an enemy.
signal hit


# Declare member variables here. Examples:


# Called when the node enters the scene tree for the first time.
func _ready():
	hide()
	
# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float):
	pass

func start(pos: Vector2):
	self.position = pos
	self.show()
	self.linear_velocity.x = 200
	# $CollisionShape2D.disabled = false


func _on_Player_body_entered(body):
	self.hide()  # Player disappears after being hit.
	self.emit_signal("hit")
	# Must be adeferred as we can't change physics properties on a physics callback.
	# $CollisionShape2D.set_deferred("disabled", true)
	print("Test")
	
	
