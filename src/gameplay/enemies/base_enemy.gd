class_name BaseEnemy
extends PathFollow3D

@export var data: EnemyData

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


func _physics_process(delta: float) -> void:
	data.behavior.process_behavior(delta, self)


func deal_damage() -> void:
	queue_free.call_deferred()


func take_damage(damage_taken: int) -> void:
	health -= damage_taken
	if health <= 0:
		queue_free.call_deferred()
