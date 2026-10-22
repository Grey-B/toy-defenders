class_name BaseTower
extends Node3D

@export var head: BasePart
@export var body: BasePart
@export var arms: BasePart

@onready var attack_radius: CollisionShape3D = %AttackRadius
@onready var enemy_detection: EnemyDetection = %EnemyDetection

var head_model: Node3D
var body_model: BodyPart
var left_arm_model: Node3D
var right_arm_model: Node3D
var damage: float = 10.0
var attack_spd: float = 1.0
var attack_range: float = 500.0


func _ready() -> void:
	apply_modifiers()
	attack_radius.global_scale(
		Vector3(
			attack_range / 100,
			attack_range / 100,
			attack_range / 100,
		),
	)

	instantiate_part_models()


func _process(_delta: float) -> void:
	if enemy_detection.select_target() != null:
		body_model.look_at(enemy_detection.select_target().global_position)


func apply_modifiers() -> void:
	for mod in head.stats:
		if mod.operation == mod.Operation.ADD:
			if mod.stat == mod.Stat.DAMAGE:
				damage += mod.stat
			elif mod.stat == mod.Stat.ATTACK_SPD:
				attack_spd += mod.stat
			elif mod.stat == mod.Stat.RANGE:
				attack_range += mod.stat
		else:
			if mod.stat == mod.Stat.DAMAGE:
				damage *= mod.stat
			elif mod.stat == mod.Stat.ATTACK_SPD:
				attack_spd *= mod.stat
			elif mod.stat == mod.Stat.RANGE:
				attack_range *= mod.stat
	for mod in body.stats:
		if mod.operation == mod.Operation.ADD:
			if mod.stat == mod.Stat.DAMAGE:
				damage += mod.stat
			elif mod.stat == mod.Stat.ATTACK_SPD:
				attack_spd += mod.stat
			elif mod.stat == mod.Stat.RANGE:
				attack_range += mod.stat
		else:
			if mod.stat == mod.Stat.DAMAGE:
				damage *= mod.stat
			elif mod.stat == mod.Stat.ATTACK_SPD:
				attack_spd *= mod.stat
			elif mod.stat == mod.Stat.RANGE:
				attack_range *= mod.stat
	for mod in arms.stats:
		if mod.operation == mod.Operation.ADD:
			if mod.stat == mod.Stat.DAMAGE:
				damage += mod.stat
			elif mod.stat == mod.Stat.ATTACK_SPD:
				attack_spd += mod.stat
			elif mod.stat == mod.Stat.RANGE:
				attack_range += mod.stat
		else:
			if mod.stat == mod.Stat.DAMAGE:
				damage *= mod.stat
			elif mod.stat == mod.Stat.ATTACK_SPD:
				attack_spd *= mod.stat
			elif mod.stat == mod.Stat.RANGE:
				attack_range *= mod.stat


func instantiate_part_models() -> void:
	head_model = head.model.instantiate()
	body_model = body.model.instantiate()
	left_arm_model = arms.model.instantiate()
	right_arm_model = arms.right_arm_model.instantiate()

	add_child(body_model)
	body_model.head_socket.add_child(head_model)
	body_model.left_arm_socket.add_child(left_arm_model)
	body_model.right_arm_socket.add_child(right_arm_model)
