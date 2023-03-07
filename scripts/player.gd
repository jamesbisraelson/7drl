extends CharacterBody2D

const BulletBall = preload('res://scenes/bullet_ball.tscn')
const CollapseBall = preload('res://scenes/collapse_ball.tscn')

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
		var types = ['bullet', 'collapse']
		add_ball(types[randi_range(0, len(types)-1)])


func add_ball(type: String) -> void:
	if type == 'collapse':
		add_collapse_ball()
	if type == 'bullet':
		add_bullet_ball()


func add_bullet_ball() -> void:
	var ball = BulletBall.instantiate()
	balls.append(ball)
	get_parent().add_child(ball)
	ball.global_position = global_position
	update_ball_follow()


func add_collapse_ball() -> void:
	var ball = CollapseBall.instantiate()
	balls.append(ball)
	get_parent().add_child(ball)
	ball.global_position = global_position
	update_ball_follow()


func update_ball_follow() -> void:
	balls[0].to_follow = self
	for i in range(1, len(balls)):
		balls[i].to_follow = balls[i-1]
