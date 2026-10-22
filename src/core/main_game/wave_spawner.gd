class_name WaveSpawner
extends Node

const ENEMY_PREFAB: PackedScene = preload("uid://bmrucnnh3arqc")
const ENEMY_DATA_ARRAY: Array[EnemyData] = [
	preload("uid://cl4des5tp7u2b"),
	preload("uid://drdq0fcyjyt7n"),
]

@onready var spawn_timer: Timer = %SpawnTimer

var level: BaseLevel
var path: Path3D
var wave_count: int = 2
var wave_points: int
var cur_points: int


func generate_wave() -> void:
	path = level.get_enemy_path()
	wave_points = wave_count * 5
	cur_points = wave_points

	## TODO: Make timer get smaller in larger waves
	spawn_timer.timeout.connect(spawn_enemies)
	spawn_timer.start()


func spawn_enemies() -> void:
	if wave_points == 0:
		wave_count += 1
		spawn_timer.stop()
		return

	var rand_data_id: int = randi_range(0, ENEMY_DATA_ARRAY.size() - 1)
	var enemy_data: EnemyData = ENEMY_DATA_ARRAY[rand_data_id]
	var cost: int = enemy_data.cost

	if cost <= wave_count and cost <= cur_points:
		cur_points -= cost
		var base_enemy: BaseEnemy = ENEMY_PREFAB.instantiate() as BaseEnemy
		base_enemy.data = enemy_data
		path.add_child(base_enemy)
