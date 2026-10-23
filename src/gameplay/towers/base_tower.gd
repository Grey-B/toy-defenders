class_name BaseTower
extends Node3D

@export var head: BasePart
@export var body: BasePart
@export var arms: BasePart

@onready var attack_radius: CollisionShape3D = %AttackRadius
@onready var attack_timer: Timer = %AttackTimer
@onready var projectile_spawn: Marker3D = %ProjectileSpawn
@onready var enemy_detection: EnemyDetection = %EnemyDetection
@onready var entity_root: Node3D = get_tree().get_first_node_in_group("entity_root")

var head_model: Node3D
var body_model: Body
var left_arm_model: Node3D
var right_arm_model: Node3D
var damage: int = 10
var attack_spd: float = 1.0
var attack_range: float = 500.0
var pierce: int = 1


func _ready() -> void:
	apply_modifiers()

	attack_radius.global_scale(
		Vector3(
			attack_range / 100,
			attack_range / 100,
			attack_range / 100,
		),
	)

	attack_timer.wait_time /= attack_spd
	attack_timer.timeout.connect(attack)

	instantiate_part_models()


func _process(_delta: float) -> void:
	var target := enemy_detection.select_target()
	if target != null:
		body_model.look_at(target.global_position)
		body_model.rotate_y(deg_to_rad(180))
		if attack_timer.is_stopped():
			attack_timer.start()
			attack()


func apply_modifiers() -> void:
	for mod in head.stats:
		if mod.operation == mod.Operation.ADD:
			if mod.stat == mod.Stat.DAMAGE:
				damage = ceil(damage + mod.value)
			elif mod.stat == mod.Stat.ATTACK_SPD:
				attack_spd += mod.value
			elif mod.stat == mod.Stat.RANGE:
				attack_range += mod.value
			elif mod.stat == mod.Stat.RANGE:
				pierce = ceil(pierce + mod.value)
		elif mod.operation == mod.Operation.MULTIPLY:
			if mod.stat == mod.Stat.DAMAGE:
				damage = ceil(damage * mod.value)
			elif mod.stat == mod.Stat.ATTACK_SPD:
				attack_spd *= mod.value
			elif mod.stat == mod.Stat.RANGE:
				attack_range *= mod.value
			elif mod.stat == mod.Stat.PIERCE:
				pierce = ceil(pierce * mod.value)

	for mod in body.stats:
		if mod.operation == mod.Operation.ADD:
			if mod.stat == mod.Stat.DAMAGE:
				damage = ceil(damage + mod.value)
			elif mod.stat == mod.Stat.ATTACK_SPD:
				attack_spd += mod.value
			elif mod.stat == mod.Stat.RANGE:
				attack_range += mod.value
			elif mod.stat == mod.Stat.RANGE:
				pierce = ceil(pierce + mod.value)
		elif mod.operation == mod.Operation.MULTIPLY:
			if mod.stat == mod.Stat.DAMAGE:
				damage = ceil(damage * mod.value)
			elif mod.stat == mod.Stat.ATTACK_SPD:
				attack_spd *= mod.value
			elif mod.stat == mod.Stat.RANGE:
				attack_range *= mod.value
			elif mod.stat == mod.Stat.PIERCE:
				pierce = ceil(pierce * mod.value)

	for mod in arms.stats:
		if mod.operation == mod.Operation.ADD:
			if mod.stat == mod.Stat.DAMAGE:
				damage = ceil(damage + mod.value)
			elif mod.stat == mod.Stat.ATTACK_SPD:
				attack_spd += mod.value
			elif mod.stat == mod.Stat.RANGE:
				attack_range += mod.value
			elif mod.stat == mod.Stat.RANGE:
				pierce = ceil(pierce + mod.value)
		elif mod.operation == mod.Operation.MULTIPLY:
			if mod.stat == mod.Stat.DAMAGE:
				damage = ceil(damage * mod.value)
			elif mod.stat == mod.Stat.ATTACK_SPD:
				attack_spd *= mod.value
			elif mod.stat == mod.Stat.RANGE:
				attack_range *= mod.value
			elif mod.stat == mod.Stat.PIERCE:
				pierce = ceil(pierce * mod.value)


func instantiate_part_models() -> void:
	head_model = head.model.instantiate()
	body_model = body.model.instantiate()
	left_arm_model = arms.model.instantiate()
	right_arm_model = arms.right_arm_model.instantiate()

	add_child(body_model)
	body_model.head_socket.add_child(head_model)
	body_model.left_arm_socket.add_child(left_arm_model)
	body_model.right_arm_socket.add_child(right_arm_model)


func attack() -> void:
	var attack_instance := arms.projectile.instantiate() as BaseProjectile

	attack_instance.direction = body_model.rotation
	attack_instance.spawn_position = projectile_spawn.global_position
	attack_instance.rotation_basis = body_model.global_transform.basis
	attack_instance.damage = damage
	attack_instance.pierce = pierce

	entity_root.add_child(attack_instance)
