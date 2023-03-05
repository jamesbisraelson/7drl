extends CharacterBody2D

@export var follow_speed: float
var to_follow: Node2D

func _physics_process(delta: float) -> void:
	global_position = global_position.lerp(to_follow.global_position, follow_speed * delta)
	rotation = to_follow.rotation