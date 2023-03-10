extends Node2D

const Spawner = preload('res://scenes/spawner.tscn')


func _on_enemy_spawn_timer_timeout() -> void:
	var spawn_pos = Vector2(randf_range(20, 300), randf_range(20, 160))
	var spawner = Spawner.instantiate()
	add_child(spawner)
	spawner.global_position = spawn_pos