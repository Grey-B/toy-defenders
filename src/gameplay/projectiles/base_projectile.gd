class_name BaseProjectile
extends CharacterBody3D

@export var speed: float = 50

var direction: Vector3
var spawn_position: Vector3
var spawn_rotation: Vector3


func _ready() -> void:
	global_position = spawn_position
	rotation = spawn_rotation


func _physics_process(_delta: float) -> void:
	velocity = direction * speed
	move_and_slide()
