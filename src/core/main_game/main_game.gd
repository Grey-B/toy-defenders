class_name MainGame
extends Node

@onready var wave_spawner: WaveSpawner = %WaveSpawner

@onready var level_root: Node3D = %LevelRoot
@onready var entity_root: Node3D = %EntityRoot
@onready var effect_root: Node3D = %EffectRoot

@onready var hud_root: Control = %HudRoot
@onready var pause_root: Control = %PauseRoot
@onready var transition_root: Control = %TransitionRoot
@onready var debug_root: Control = %DebugRoot

const TEST_LEVEL_1_UID: String = "uid://ba0k6u41pfd88"

var current_level: BaseLevel = null


func _ready() -> void:
	get_window().grab_focus.call_deferred()
	load_level(TEST_LEVEL_1_UID)


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
	wave_spawner.level = current_level
	wave_spawner.generate_wave()
