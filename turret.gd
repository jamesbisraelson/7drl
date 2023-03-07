extends CharacterBody2D

const Bullet = preload('res://scenes/turret_bullet.tscn')

@export var health: float
@export var move_amount: float


func _ready() -> void:
	move()


func move():
	var new_rot = move_toward(rotation, rotation + wrapf(global_position.angle_to_point(get_closest_enemy_pos()) - rotation, -PI, PI), PI/4)
	var new_pos = Vector2(move_amount, 0).rotated(new_rot)

	var tween = get_tree().create_tween()
	tween.set_ease(Tween.EASE_IN_OUT)
	tween.set_trans(Tween.TRANS_SINE)
	tween.tween_property(self, 'rotation', new_rot, 0.5)
	tween.tween_property(self, 'global_position', new_pos, 1).as_relative()
	tween.tween_callback(move)

	var tween2 = get_tree().create_tween()
	tween2.tween_property(self, 'scale:x', scale.x, 0.5)
	tween2.tween_property(self, 'scale:x', scale.x * 1.25, 0.5)
	tween2.tween_property(self, 'scale:x', scale.x, 0.5)


func get_closest_enemy_pos():
	var enemies = get_tree().get_nodes_in_group('enemies')
	if len(enemies) > 0:
		var closest = enemies[0]
		for enemy in enemies:
			if global_position.distance_squared_to(enemy.global_position) < global_position.distance_squared_to(closest.global_position):
				closest = enemy
	
		return closest.global_position
	return global_position + Vector2(1, 0).rotated(rotation)

func _on_action_timer_timeout() -> void:
	shoot()


func kill():
	await get_tree().process_frame
	queue_free()


func shoot():
	var enemies = get_tree().get_nodes_in_group('enemies')
	if len(enemies) > 0:
		var closest = enemies[0]
		for enemy in enemies:
			if global_position.distance_squared_to(enemy.global_position) < global_position.distance_squared_to(closest.global_position):
				closest = enemy

		if global_position.distance_to(closest.global_position) < 50:
			var bullet = Bullet.instantiate()
			get_parent().add_child(bullet)
			bullet.global_position = global_position
			bullet.look_at(closest.global_position)
