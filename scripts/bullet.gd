extends CharacterBody2D

@export var move_speed: float


func _process(delta: float) -> void:
	velocity = Vector2(move_speed, 0).rotated(rotation)
	var collision: KinematicCollision2D = move_and_collide(velocity * delta)
	if collision and collision.get_collider().is_in_group('enemies'):
		collision.get_collider().kill()
		await get_tree().process_frame
		queue_free()
