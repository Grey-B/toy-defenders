class_name BaseEnemy
extends PathFollow3D

@export var data: EnemyData
@export var hurtbox: Area3D

var enemy_name: String
var model_instance: Node3D
var speed: float
var health: int
var damage: int


func _ready() -> void:
	enemy_name = data.name
	model_instance = data.model.instantiate()
	speed = data.speed
	health = data.health
	damage = data.damage

	add_child(model_instance)

	hurtbox.body_entered.connect(take_damage)


func _physics_process(delta: float) -> void:
	data.behavior.process_behavior(delta, self)


func deal_damage() -> void:
	queue_free.call_deferred()


func take_damage(body: Node3D) -> void:
	if body is BaseProjectile:
		health -= body.damage
		if health <= 0:
			call_deferred("queue_free")
