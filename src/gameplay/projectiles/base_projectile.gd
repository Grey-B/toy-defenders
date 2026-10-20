class_name BaseProjectile
extends CharacterBody3D

@export var speed: float = 10
@export var duration_timer: Timer

var direction: Vector3
var spawn_position: Vector3


func _ready() -> void:
	global_position = spawn_position
	global_rotation = direction
	duration_timer.timeout.connect(queue_free)
