class_name Ball extends CharacterBody2D

const Bullet = preload('res://scenes/bullet.tscn')
const Turret = preload('res://scenes/turret.tscn')

const COLLAPSE_CHANCE = 0.01
const TURRET_VELOCITY = 200.0
const SHOOT_DISTANCE = 100.0

@export var follow_speed: float
@export var max_health: float
var health: float
@export_enum('bullet', 'turret', 'collapse') var type: String

var to_follow: Node2D
var shadow_offset: Vector2


func _ready():
	health = max_health
	shadow_offset = $Shadow.position
	$HealthBar.modulate.a = 0.0
	add_to_group(type)


func _process(_delta: float) -> void:
	$HealthBar.value = health


func _physics_process(delta: float) -> void:
	$Shadow.rotation = to_follow.rotation
	$Shadow.global_position = global_position + shadow_offset
	$Sprite2D.rotation = to_follow.rotation

	if to_follow is Player:
		global_position = to_follow.global_position
	else:
		global_position = global_position.lerp(to_follow.global_position, follow_speed * delta)


func _on_action_timer_timeout() -> void:
	if type == 'bullet':
		shoot_bullet()
	if type == 'turret':
		drop_turret()


func shoot_bullet() -> void:
	var enemies = get_tree().get_nodes_in_group('enemies')
	if len(enemies) > 0:
		var closest = enemies[0]
		for enemy in enemies:
			if global_position.distance_squared_to(enemy.global_position) < global_position.distance_squared_to(closest.global_position):
				closest = enemy

		if global_position.distance_to(closest.global_position) < SHOOT_DISTANCE:
			var bullet = Bullet.instantiate()
			get_parent().add_child(bullet)
			bullet.global_position = global_position
			bullet.look_at(closest.global_position)


func drop_turret():
	var turret = Turret.instantiate()
	get_parent().add_child(turret)
	turret.global_position = self.global_position
	turret.velocity = Vector2(randf_range(-1.0, 1.0), randf_range(-1.0, 1.0)).normalized() * TURRET_VELOCITY


func collapse_enemies():
	if randf() < COLLAPSE_CHANCE:
		var enemies = get_tree().get_nodes_in_group('enemies')
		for enemy in enemies:
			enemy.take_damage(enemy.max_health)


func take_damage(amount: float) -> void:
	if health > 0:
		health -= amount

		health_bar_anim()
		hit_anim()

		if health <= 0:
			kill()


func kill():
	var player: Player = get_node('/root/Game/Player')
	player.remove_ball(self)
	queue_free()


func hit_anim() -> Tween:
	var tween = create_tween()
	tween.tween_property($Sprite2D, 'modulate', Color(10, 10, 10), 0.05)
	tween.tween_property($Sprite2D, 'modulate', Color(1, 1, 1), 0.05)
	return tween


func health_bar_anim() -> void:
	var tween = create_tween()
	tween.tween_property($HealthBar, 'modulate:a', 1.0, 0.25)
	tween.tween_interval(3.0)
	tween.tween_property($HealthBar, 'modulate:a', 0.0, 0.25)
