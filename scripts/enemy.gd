extends CharacterBody2D

@export var move_speed: float
@export var rotate_speed: float


func _process(delta: float) -> void:
	$Sprite2D.rotation += delta * rotate_speed
	var player: CharacterBody2D = get_node('/root/Game/Player')
	var direction: Vector2 = global_position.direction_to(player.global_position).normalized()
	velocity = direction * move_speed
	var collision: KinematicCollision2D = move_and_collide(velocity * delta)
	if collision and collision.get_collider().is_in_group('bullets'):
		await get_tree().process_frame
		queue_free()
		
