class_name TestLevel1
extends BaseLevel

@onready var enemy_path: Path3D = %EnemyPath


func get_enemy_path() -> Path3D:
	return enemy_path
