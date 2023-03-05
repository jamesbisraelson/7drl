extends CharacterBody2D

@export var move_speed: float


func _process(delta: float) -> void:
	velocity = Vector2(move_speed, 0).rotated(rotation)
	move_and_slide()
