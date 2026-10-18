class_name TestLevel1
extends BaseLevel

@onready var player_spawn: PlayerSpawn = %PlayerSpawn
# TODO: change to camera syster manager
@onready var camera: Camera3D = %Camera3D


func get_default_player_spawn() -> Vector3:
	return player_spawn.global_position


func get_player_camera() -> Camera3D:
	return camera
