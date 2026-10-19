class_name TestLevel1
extends BaseLevel

@onready var player_spawn: PlayerSpawn = %PlayerSpawn
# TODO: change to camera syster manager


func get_default_player_spawn() -> Vector3:
	return player_spawn.global_position
