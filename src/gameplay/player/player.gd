class_name Player
extends CharacterBody3D

enum States { IDLE, MOVE }

@export var speed: float

var active_state: States = States.IDLE


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
