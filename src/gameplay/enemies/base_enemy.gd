class_name BaseEnemy
extends CharacterBody3D

@export var data: EnemyData

var enemy_name: String
var model_instance: Node3D
var speed: float
var health: int


func _ready() -> void:
	enemy_name = data.name
	model_instance = data.model.instantiate()
	speed = data.speed
	health = data.health

	add_child(model_instance)


func _physics_process(_delta: float) -> void:
	data.behavior.process_behavior(self)
	velocity.y = 0


func take_damage(damage: int) -> void:
	health -= damage
	if health <= 0:
		call_deferred("queue_free")
