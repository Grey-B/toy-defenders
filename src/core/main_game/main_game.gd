class_name MainGame
extends Node

@onready var level_root: Node3D = %LevelRoot
@onready var entity_root: Node3D = %EntityRoot
@onready var effect_root: Node3D = %EffectRoot

@onready var hud_root: Control = %HudRoot
@onready var pause_root: Control = %PauseRoot
@onready var transition_root: Control = %TransitionRoot
@onready var debug_root: Control = %DebugRoot

const TEST_LEVEL_1_UID: String = "uid://ba0k6u41pfd88"
const PLAYER_UID: String = "uid://bro1da23d1j3v"

var player: Player = null
var current_level: BaseLevel = null


func _ready() -> void:
	get_window().grab_focus.call_deferred()
	init_player()
	load_level(TEST_LEVEL_1_UID)


func init_player() -> void:
	var player_scene: PackedScene = ResourceLoader.load(PLAYER_UID) as PackedScene
	if player_scene == null:
		push_error("Could not load player scene: " + PLAYER_UID)
		return

	player = player_scene.instantiate() as Player
	if player == null:
		push_error("Loaded player scene does not extend Player or DNE: " + PLAYER_UID)
		return

	entity_root.add_child(player)


func load_level(level_scene: String) -> void:
	deffered_load_level.call_deferred(level_scene)


func deffered_load_level(level_scene_uid: String) -> void:
	if current_level != null:
		current_level.queue_free()
		current_level = null
		await get_tree().process_frame

	var new_level_packed: PackedScene = \
			ResourceLoader.load(level_scene_uid, "PackedScene") as PackedScene
	if new_level_packed == null:
		push_error("Could not load level as packed scene: " + level_scene_uid)
		return

	var new_level: Node = new_level_packed.instantiate()
	if not new_level:
		push_error("Could not instantiate new level: " + level_scene_uid)
		return

	if not new_level is BaseLevel:
		new_level.free()
		push_error("Loaded level is not of type BaseLevel: " + level_scene_uid)
		return

	current_level = new_level as BaseLevel
	# TODO add fall back scene

	level_root.add_child(current_level)

	place_player_at_level_spawn()
	check_for_enemy_spawn()
	#setup_camera()


func place_player_at_level_spawn() -> void:
	if player == null:
		push_error("Cannot place player in level because it is null")
		return
	if current_level == null:
		push_error("Cannot place player into level because level is null")
		return

	player.global_position = current_level.get_default_player_spawn()

#func setup_camera() -> void:
#if player == null or current_level == null:
#return
#
#var level_camera := current_level.get_player_camera()
#if level_camera == null:
#return
#
## TODO: temporary hookup
## TODO: camera_system.set_target(player)


func check_for_enemy_spawn() -> void:
	var timer := current_level.get_enemy_spawn_timer()
	if timer != null:
		timer.timeout.connect(spawn_enemy)


func spawn_enemy() -> void:
	var enemy: PackedScene = ResourceLoader.load(current_level.ENEMY_UID_ARRAY[0]) \
			as PackedScene
	if enemy == null:
		push_error("Could not load enemy scene: " + current_level.ENEMY_UID_ARRAY[0])
		return

	var enemy_instance = enemy.instantiate() as BaseEnemy
	if enemy_instance == null:
		push_error(
			"Loaded enemy scene does not extend BaseEnemy or DNE: "
			+ current_level.ENEMY_UID_ARRAY[0],
		)
		return

	enemy_instance.data = current_level.ENEMY_DATA_ARRAY[0]
	entity_root.add_child(enemy_instance)

	player.enemy_path_follow.progress_ratio = randf()
	enemy_instance.global_position = player.enemy_path_follow.global_position
