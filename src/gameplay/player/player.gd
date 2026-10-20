class_name Player
extends CharacterBody3D

enum States { IDLE, MOVE }

@export var enemy_path_follow: PathFollow3D
@export var data: PlayerData
@export var equipped_weapon: WeaponData

@onready var entity_root: Node3D = get_tree().get_first_node_in_group("entity_root")
@onready var collision_shape_3d: CollisionShape3D = %CollisionShape3D
@onready var projectile_spawn: Marker3D = %ProjectileSpawn

var active_state: States = States.IDLE
var model_instance: Node3D
var speed: float
var max_health: int
var cur_health: int
var attack_speed: float = 1.0
var attack_timer: Timer = Timer.new()


func _ready() -> void:
	model_instance = data.ancestry.model.instantiate()
	speed = data.speed * data.ancestry.speed_mult * data.player_class.speed_mult
	max_health = int(data.max_health * data.ancestry.health_mult * data.player_class.health_mult)
	cur_health = max_health
	attack_speed /= equipped_weapon.attack_speed

	collision_shape_3d.add_child(model_instance)
	add_child(attack_timer)

	attack_timer.start()
	attack_timer.one_shot = false
	# TODO: replace with manual attack toggle

	attack_timer.wait_time = attack_speed
	attack_timer.timeout.connect(attack)


func _physics_process(_delta: float) -> void:
	var input_dir := Input.get_vector(
		"move_left",
		"move_right",
		"move_up",
		"move_down",
	)
	var direction := (
			transform.basis * Vector3(input_dir.x, 0, input_dir.y)
	).normalized()

	if input_dir:
		set_state(States.MOVE)
	else:
		set_state(States.IDLE)

	if active_state == States.MOVE:
		collision_shape_3d.rotation.y = lerp_angle(
			collision_shape_3d.rotation.y,
			atan2(velocity.x, velocity.z),
			0.15,
		)
		velocity.x = direction.x * speed
		velocity.z = direction.z * speed
	elif active_state == States.IDLE:
		velocity.x = move_toward(velocity.x, 0, speed)
		velocity.z = move_toward(velocity.z, 0, speed)

	move_and_slide()


func set_state(new_state: States) -> void:
	active_state = new_state


func attack() -> void:
	var attack_instance = equipped_weapon.attack_model.instantiate() as BaseProjectile
	attack_instance.direction = collision_shape_3d.rotation
	attack_instance.spawn_position = projectile_spawn.global_position
	attack_instance.rotation_basis = collision_shape_3d.global_transform.basis
	entity_root.add_child(attack_instance)


func take_damage(damage: int) -> void:
	cur_health -= damage
	print(
		"Took " + str(damage) + " damage. Current health: " \
				+ str(cur_health) + "/" + str(max_health),
	)
	if cur_health < 0:
		cur_health = 0
	if cur_health == 0:
		queue_free()
