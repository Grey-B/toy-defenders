extends Control

@onready var fps_label: Label = %FpsLabel
@onready var version_label: Label = %VersionLabel

const VERSION_SETTING: String = "application/config/version"


func _ready() -> void:
	add_version_to_label()


func _process(_delta: float) -> void:
	fps_label.set_text("FPS: " + str(Engine.get_frames_per_second()))


func add_version_to_label() -> void:
	var version_str: String = ProjectSettings.get_setting(VERSION_SETTING)
	version_label.text += version_str
