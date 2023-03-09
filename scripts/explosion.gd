extends Sprite2D

func _ready() -> void:
	var tween = create_tween()
	tween.tween_property(self, 'scale', Vector2.ZERO, 0.25)
	tween.tween_callback(queue_free)
