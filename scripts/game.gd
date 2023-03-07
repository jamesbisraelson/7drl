extends Node2D

const Enemy = preload('res://scenes/enemy.tscn')


func _on_enemy_spawn_timer_timeout() -> void:
	var side = randi_range(0, 3)
	var enemy = Enemy.instantiate()
	add_child(enemy)

	if side == 0:
		enemy.global_position = Vector2(randf_range(0, 320), -16)
	elif side == 1:
		enemy.global_position = Vector2(randf_range(0, 320), 320 + 16)
	elif side == 2:
		enemy.global_position = Vector2(-16, randf_range(0, 320))
	elif side == 3:
		enemy.global_position = Vector2(320 + 16, randf_range(0, 320))