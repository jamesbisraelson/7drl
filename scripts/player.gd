class_name Player extends CharacterBody2D

const BulletBall = preload('res://scenes/shooter_ball.tscn')
const CollapseBall = preload('res://scenes/collapse_ball.tscn')
const TurretBall = preload('res://scenes/turret_ball.tscn')

@export var move_speed: float
@export var rotation_speed: float

var direction: float
var balls: Array
var shadow_offset: Vector2


func _physics_process(delta: float) -> void:
	get_input()
	rotation += direction * rotation_speed * delta
	velocity = Vector2(move_speed, 0).rotated(rotation)
	move_and_slide()


func get_input() -> void:
	direction = Input.get_axis('game_left', 'game_right')


func _unhandled_input(event: InputEvent) -> void:
	if event.is_action_pressed('ui_down'):
		var types = ['bullet', 'bullet', 'collapse', 'turret']
		add_ball(types[randi_range(0, len(types)-1)])
	if event.is_action_pressed('ui_up'):
		balls[0].take_damage(101)


func add_ball(type: String) -> void:
	var ball: Ball
	if type == 'collapse':
		ball = CollapseBall.instantiate()
	elif type == 'bullet':
		ball = BulletBall.instantiate()
	elif type == 'turret':
		ball = TurretBall.instantiate()
	balls.append(ball)
	get_parent().add_child(ball)
	ball.global_position = global_position
	ball.player = self
	update_ball_follow()


func remove_ball(ball: Ball) -> void:
	var index = balls.find(ball)
	if index >= 0:
		balls.pop_at(index)
		update_ball_follow()


func update_ball_follow() -> void:
	if len(balls) > 0:
		balls[0].to_follow = self
		for i in range(1, len(balls)):
			balls[i].to_follow = balls[i-1]
		reorder_balls()


func reorder_balls() -> void:
	for i in range(balls.size(), 0, -1):
		get_parent().move_child(balls[i - 1], -1)
