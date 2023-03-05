extends CharacterBody2D

const Ball = preload('res://scenes/ball.tscn')
const Bullet = preload('res://scenes/bullet.tscn')

@export var move_speed: float
@export var rotation_speed: float

var direction: float
var balls: Array


func _physics_process(delta: float) -> void:
	get_input()
	rotation += direction * rotation_speed * delta
	velocity = Vector2(move_speed, 0).rotated(rotation)
	move_and_slide()


func get_input() -> void:
	direction = Input.get_axis('game_left', 'game_right')


func _unhandled_input(event: InputEvent) -> void:
	if event.is_action_pressed('ui_down'):
		add_ball()


func add_ball() -> void:
	var ball = Ball.instantiate()
	balls.append(ball)
	get_parent().add_child(ball)
	ball.global_position = global_position
	update_ball_follow()


func update_ball_follow() -> void:
	balls[0].to_follow = self
	for i in range(1, len(balls)):
		balls[i].to_follow = balls[i-1]


func _on_bullet_timer_timeout() -> void:
	var enemies = get_tree().get_nodes_in_group('enemies')
	var closest = enemies[0]
	for enemy in enemies:
		if global_position.distance_squared_to(enemy.global_position) < global_position.distance_squared_to(closest.global_position):
			closest = enemy

	var bullet = Bullet.instantiate()
	get_parent().add_child(bullet)
	bullet.global_position = global_position
	bullet.look_at(closest.global_position)
