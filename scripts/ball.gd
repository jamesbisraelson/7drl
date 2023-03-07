extends CharacterBody2D

const Bullet = preload('res://scenes/bullet.tscn')
const Turret = preload('res://scenes/turret.tscn')
const COLLAPSE_CHANCE = 0.01

@export var follow_speed: float
@export var health: float
@export_enum('bullet', 'turret', 'collapse') var type: String

var to_follow: Node2D


func _ready():
	print(type)
	add_to_group(type)


func _physics_process(delta: float) -> void:
	global_position = global_position.lerp(to_follow.global_position, follow_speed * delta)
	rotation = to_follow.rotation


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

		if global_position.distance_to(closest.global_position) < 50:
			var bullet = Bullet.instantiate()
			get_parent().add_child(bullet)
			bullet.global_position = global_position
			bullet.look_at(closest.global_position)


func drop_turret():
	var turret = Turret.instantiate()
	get_parent().add_child(turret)
	turret.global_position = self.global_position


func collapse_enemies():
	if randf() < 0.01:
		var enemies = get_tree().get_nodes_in_group('enemies')
		for enemy in enemies:
			enemy.kill()