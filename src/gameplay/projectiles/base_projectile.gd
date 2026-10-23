class_name BaseProjectile
extends CharacterBody3D

@export var speed: float
@export var hitbox: Area3D

var direction: Vector3
var spawn_position: Vector3
var rotation_basis: Basis
var damage: int
var pierce: int
var enemies_pierced: int = 0


func _ready() -> void:
	global_position = spawn_position
	global_rotation = direction
	hitbox.area_entered.connect(deal_damage)


func _physics_process(delta: float) -> void:
	global_position += rotation_basis.z * speed * delta


func deal_damage(area: Area3D) -> void:
	if area is Hurtbox:
		area.get_parent().take_damage(damage)
		enemies_pierced += 1
		if enemies_pierced >= pierce:
			queue_free.call_deferred()
