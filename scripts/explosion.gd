extends Sprite2D

func _ready() -> void:
	var tween = create_tween()
	tween.tween_property(self, 'scale', 1.0, 2.0)
