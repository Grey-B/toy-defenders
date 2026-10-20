class_name BaseProjectile
extends CharacterBody3D

@export var speed: float
@export var duration_timer: Timer

var direction: Vector3
var spawn_position: Vector3
var rotation_basis: Basis


func _ready() -> void:
	global_position = spawn_position
	global_rotation = direction
	duration_timer.timeout.connect(queue_free)


func _physics_process(delta: float) -> void:
	global_position += rotation_basis.z * speed * delta
