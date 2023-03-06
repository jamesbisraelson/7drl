extends Node2D

const Enemy = preload('res://scenes/enemy.tscn')


func _on_enemy_spawn_timer_timeout() -> void:
	var enemy = Enemy.instantiate()
	add_child(enemy)
	enemy.global_position = Vector2(randf_range(0, 320), -16)