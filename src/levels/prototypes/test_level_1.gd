class_name TestLevel1
extends BaseLevel

@onready var player_spawn: PlayerSpawn = %PlayerSpawn
@onready var enemy_spawn_timer: Timer = %EnemySpawnTimer

const ENEMY_UID_ARRAY: Array[String] = ["uid://bmrucnnh3arqc"]
const ENEMY_DATA_ARRAY: Array[Resource] = [preload("uid://cl4des5tp7u2b")]


func get_default_player_spawn() -> Vector3:
	return player_spawn.global_position


func get_enemy_spawn_timer() -> Timer:
	return enemy_spawn_timer
