extends CharacterBody2D

func _ready() -> void:
	rotate_tween()

func rotate_tween() -> void:
	var choices = [1, -1]
	var direction = choices[randi_range(0, len(choices)-1)]
	var tween = get_tree().create_tween()
	tween.set_trans(Tween.TRANS_ELASTIC)
	tween.tween_property(self, 'rotation', rotation + deg_to_rad(90 * direction), 3.0);
	tween.tween_callback(rotate_tween)
