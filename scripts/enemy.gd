extends CharacterBody2D

const Explosion = preload('res://scenes/explosion.tscn')
const SmallExplosion = preload('res://scenes/small_explosion.tscn')

const SMALL_EXPLOSION_NUM = 3

@export var move_speed: float
@export var rotation_speed: float
@export var max_health: float
@export var damage: float

var health: float
var shadow_offset: Vector2


func _ready() -> void:
	health = max_health
	$HealthBar.modulate.a = 0.0
	shadow_offset = $Shadow.position


func _process(_delta: float) -> void:
	$HealthBar.value = health


func _physics_process(delta: float) -> void:
	$Sprite2D.rotation += delta * rotation_speed
	$Shadow.rotation += delta * rotation_speed
	$Shadow.global_position = global_position + shadow_offset

	var player: Player = get_node('/root/Game/Player')
	var direction: Vector2 = global_position.direction_to(player.global_position).normalized()
	velocity = direction * move_speed
	var collision = move_and_collide(velocity * delta)

	if collision:
		on_collision(collision.get_collider())


func on_collision(collision_obj: Object):
	if collision_obj is Ball:
		collision_obj.take_damage(damage)
		take_damage(max_health)


func take_damage(amount: float) -> void:
	if health > 0:
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

	var e = Explosion.instantiate()
	e.global_position = self.global_position
	get_parent().add_child(e)

	for i in SMALL_EXPLOSION_NUM:
		var small_e = SmallExplosion.instantiate()
		small_e.global_position = self.global_position
		get_parent().add_child(small_e)
	
	queue_free()
