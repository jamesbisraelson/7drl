extends Sprite2D

const Enemy = preload('res://scenes/enemy.tscn')

@export var rotation_speed: float

var shadow_offset: Vector2


func _ready() -> void:
	shadow_offset = $Shadow.position
	scale = Vector2.ZERO

	var tween = create_tween()
	tween.set_ease(Tween.EASE_IN_OUT)
	tween.set_trans(Tween.TRANS_SINE)
	tween.tween_property(self, 'scale', Vector2.ONE, 1.5)
	tween.tween_callback(spawn_enemies)
	tween.tween_property(self, 'scale', Vector2.ZERO, 1.5)
	tween.tween_callback(queue_free)


func _process(delta: float) -> void:
	rotation += delta * rotation_speed
	$Shadow.global_position = global_position + shadow_offset

func spawn_enemies():
	for i in randi_range(3, 10):
		var enemy = Enemy.instantiate()
		get_parent().add_child(enemy)
		enemy.global_position = self.global_position + Vector2(randf_range(-16.0, 16.0), randf_range(-16.0, 16.0))