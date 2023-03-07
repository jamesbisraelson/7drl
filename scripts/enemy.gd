extends CharacterBody2D

@export var move_speed: float
@export var rotate_speed: float
@export var health: float


func _process(delta: float) -> void:
	$Sprite2D.rotation += delta * rotate_speed
	var player: CharacterBody2D = get_node('/root/Game/Player')
	var direction: Vector2 = global_position.direction_to(player.global_position).normalized()
	velocity = direction * move_speed
	move_and_collide(velocity * delta)

func take_damage(amount: float):
	health -= amount

func kill():
	queue_free()

func _exit_tree() -> void:
	var collapse_balls = get_tree().get_nodes_in_group('collapse')
	for ball in collapse_balls:
		ball.collapse_enemies()