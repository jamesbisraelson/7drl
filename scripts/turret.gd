class_name Turret extends CharacterBody2D

const Bullet = preload('res://scenes/turret_bullet.tscn')

@export var max_health: float
@export var move_amount: float
@export var deceleration: float

var health: float
var shadow_offset: Vector2


func _ready() -> void:
	health = max_health
	$HealthBar.modulate.a = 0.0
	shadow_offset = $Shadow.position
	move()


func _process(_delta: float) -> void:
	$Shadow.global_rotation = $Sprite2D.global_rotation
	$Shadow.global_position = global_position + shadow_offset
	$HealthBar.value = health


func _physics_process(delta: float) -> void:
	velocity = velocity.move_toward(Vector2.ZERO, deceleration * delta)
	move_and_collide(velocity * delta)


func move() -> Tween:
	var new_rot = move_toward($Sprite2D.rotation, $Sprite2D.rotation + wrapf(global_position.angle_to_point(get_closest_enemy_pos()) - $Sprite2D.rotation, -PI, PI), PI/4)
	var new_pos = Vector2(1, 0).rotated(new_rot) * move_amount

	var tween = create_tween()
	tween.set_ease(Tween.EASE_IN_OUT)
	tween.set_trans(Tween.TRANS_SINE)
	tween.tween_property($Sprite2D, 'rotation', new_rot, 0.5)
	tween.tween_property(self, 'global_position', new_pos, 1).as_relative()
	tween.tween_callback(move)

	var tween2 = create_tween()
	tween2.tween_interval(0.5)
	tween2.tween_property($Sprite2D, 'scale:x', scale.x * 1.25, 0.5)
	tween2.tween_property($Sprite2D, 'scale:x', scale.x, 0.5)

	var tween3 = create_tween()
	tween3.tween_interval(0.5)
	tween3.tween_property($Shadow, 'scale:x', scale.x * 1.25, 0.5)
	tween3.tween_property($Shadow, 'scale:x', scale.x, 0.5)

	return tween


func get_closest_enemy_pos():
	var enemies = get_tree().get_nodes_in_group('enemies')
	if len(enemies) > 0:
		var closest = enemies[0]
		for enemy in enemies:
			if global_position.distance_squared_to(enemy.global_position) < global_position.distance_squared_to(closest.global_position):
				closest = enemy
	
		return closest.global_position
	return global_position + Vector2(1, 0).rotated($Sprite2D.rotation)

func _on_action_timer_timeout() -> void:
	shoot()


func shoot():
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


func take_damage(amount: float) -> void:
	if health > 0:
		health -= amount

		health_bar_anim()
		hit_anim()

		if health <= 0:
			kill()


func kill():
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
