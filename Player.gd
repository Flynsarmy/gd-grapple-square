extends RigidBody2D

# Define a custom signal called "hit" that we will have our player emit when it collides with an enemy.
# signal hit


# Declare member variables here. Examples:


# Called when the node enters the scene tree for the first time.
func _ready():
	hide()
	
# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta: float):
	pass

func start(pos: Vector2):
	self.position = pos
	self.show()
	self.linear_velocity.x = 200
	# $CollisionShape2D.disabled = false
