class_name Player
extends CharacterBody3D

enum States { IDLE, MOVE }

@export var enemy_path_follow: PathFollow3D
@export var data: PlayerData

var active_state: States = States.IDLE
var model_instance: Node3D
var speed: float
var max_health: int
var cur_health: int


func _ready() -> void:
	model_instance = data.ancestry.model.instantiate()
	speed = data.speed * data.ancestry.speed_mult * data.player_class.speed_mult
	max_health = int(data.max_health * data.ancestry.health_mult * data.player_class.health_mult)
	cur_health = max_health

	add_child(model_instance)


func _physics_process(_delta: float) -> void:
	var input_dir := Input.get_vector(
		"move_left",
		"move_right",
		"move_up",
		"move_down",
	)
	var direction := (
			transform.basis * Vector3(input_dir.x, 0, input_dir.y)
	).normalized()

	if input_dir:
		set_state(States.MOVE)
	else:
		set_state(States.IDLE)

	if active_state == States.MOVE:
		velocity.x = direction.x * speed
		velocity.z = direction.z * speed
	elif active_state == States.IDLE:
		velocity.x = move_toward(velocity.x, 0, speed)
		velocity.z = move_toward(velocity.z, 0, speed)

	move_and_slide()


func set_state(new_state: States) -> void:
	active_state = new_state


func take_damage(damage: int) -> void:
	cur_health -= damage
	print(
		"Took " + str(damage) + " damage. Current health: " \
				+ str(cur_health) + "/" + str(max_health),
	)
	if cur_health < 0:
		cur_health = 0
	if cur_health == 0:
		queue_free()
