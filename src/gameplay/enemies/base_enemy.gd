class_name BaseEnemy
extends CharacterBody3D

@export var data: EnemyData

@onready var player: Player = get_tree().get_first_node_in_group("player")
@onready var contact_hitbox: Area3D = %ContactHitbox

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
	data.behavior.process_behavior(self, player)
	velocity.y = 0


func _on_contact_hitbox_body_entered(body: Node3D) -> void:
	if body is Player:
		body.take_damage(data.behavior.contact_damage)


func take_damage(damage: int) -> void:
	health -= damage
	if health <= 0:
		call_deferred("queue_free")
