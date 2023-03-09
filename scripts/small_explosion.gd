extends Sprite2D

@export var move_amount: float

func _ready() -> void:
	var direction = Vector2(randf_range(-1.0, 1.0), randf_range(-1.0, 1.0)).normalized()
	var tween = create_tween()
	tween.set_parallel()
	tween.tween_property(self, 'position', direction * move_amount, 0.25).as_relative()
	tween.tween_property(self, 'scale', Vector2.ZERO, 0.25)
	tween.set_parallel(false)
	tween.tween_callback(queue_free)
