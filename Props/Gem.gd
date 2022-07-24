extends Area2D

export(int) var shard_count: int = 8     # Grid size for debris created on collision

var scn_gem_shard: PackedScene = preload("res://Props/GemShard.tscn")

onready var ShardContainer: Node2D = $ShardContainer

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	create_shards()
	#$Sprite.visible = false
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta: float) -> void:
#	pass

func create_shards() -> void:
	var sprite: Sprite = $Sprite
	var shard_size: Vector2 = sprite.region_rect.size / shard_count
	var collision_size: Vector2 = shard_size / 2 * sprite.scale
	
	var shard: RigidBody2D
	var shard_sprite: Sprite
	var shard_collision: CollisionShape2D
	var offset: Vector2
	
	for _x in shard_count:
		for _y in shard_count:
			offset = shard_size * Vector2(_x, _y)
			shard = scn_gem_shard.instance()
			shard.position = offset * sprite.scale
			
			shard_sprite = shard.get_node("Sprite")
			shard_sprite.scale = sprite.scale
			if sprite.region_enabled:
				shard_sprite.region_rect = Rect2(sprite.region_rect.position + offset, shard_size)
			else:
				shard_sprite.region_rect = Rect2(offset, shard_size)
			
			shard_collision = shard.get_node("CollisionShape2D")
			shard_collision.position = collision_size
			(shard_collision.shape as RectangleShape2D).set_extents(collision_size)

			ShardContainer.add_child(shard)
			
func _on_Gem_body_entered(_body: Node) -> void:
	for node in ShardContainer.get_children():
		node.gravity_scale = 1
	ShardContainer.visible = true
	($Sprite as Sprite).visible = false
	
	GsEvents.emit_signal("coin_acquired")
