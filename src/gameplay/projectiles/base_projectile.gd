class_name BaseProjectile
extends CharacterBody3D

@export var speed: float = 50

var direction: float
var spawn_position: Vector3
var spawn_rotation: float


func _ready() -> void:
	global_position = spawn_position
	rotation.y = spawn_rotation


func _physics_process(_delta: float) -> void:
	velocity = Vector3(0, 0, -speed)
	move_and_slide()
