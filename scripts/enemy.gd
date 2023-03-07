extends CharacterBody2D

@export var move_speed: float
@export var rotate_speed: float

var should_die: bool


func _ready() -> void:
	should_die = false


func _process(delta: float) -> void:
	$Sprite2D.rotation += delta * rotate_speed
	var player: CharacterBody2D = get_node('/root/Game/Player')
	var direction: Vector2 = global_position.direction_to(player.global_position).normalized()
	velocity = direction * move_speed
	var collision: KinematicCollision2D = move_and_collide(velocity * delta)
	if collision and collision.get_collider().is_in_group('bullets'):
		should_die = true

	if should_die:
		await get_tree().process_frame
		queue_free()


func _exit_tree() -> void:
	var collapse_balls = get_tree().get_nodes_in_group('collapse')
	for ball in collapse_balls:
		ball.collapse()