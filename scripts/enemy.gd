extends CharacterBody2D

const Explosion = preload('res://scenes/explosion.tscn')

@export var move_speed: float
@export var rotation_speed: float
@export var max_health: float

var health: float
var shadow_offset: Vector2


func _ready() -> void:
	shadow_offset = $Shadow.position
	health = max_health


func _process(delta: float) -> void:
	$HealthBar.value = health
	$Sprite2D.rotation += delta * rotation_speed
	$Shadow.rotation += delta * rotation_speed
	$Shadow.global_position = global_position + shadow_offset
	var player: CharacterBody2D = get_node('/root/Game/Player')
	var direction: Vector2 = global_position.direction_to(player.global_position).normalized()
	velocity = direction * move_speed
	move_and_collide(velocity * delta)


func take_damage(amount: float) -> void:
	health -= amount

	health_bar_anim()
	hit_anim()


	if health <= 0:
		kill()


func hit_anim() -> Tween:
	var tween = create_tween()
	tween.tween_property($Sprite2D, 'modulate', Color(10, 10, 10), 0.05)
	tween.tween_property($Sprite2D, 'modulate', Color(1, 1, 1), 0.05)
	return tween


func health_bar_anim() -> void:
	var tween = create_tween()
	tween.tween_property($HealthBar, 'modulate:a', 1.0, 0.25)
	tween.tween_interval(10.0)
	tween.tween_property($HealthBar, 'modulate:a', 0.0, 0.25)


func kill() -> void:
	var collapse_balls = get_tree().get_nodes_in_group('collapse')
	for ball in collapse_balls:
		ball.collapse_enemies()

	var explosion = Explosion.instantiate()
	explosion.global_position = self.global_position
	get_parent().add_child(explosion)
	queue_free()