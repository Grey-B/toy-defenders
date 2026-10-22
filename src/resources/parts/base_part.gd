class_name BasePart
extends Resource

enum PartTypes { HEAD, BODY, ARMS }

@export_group("Model")
@export var model: PackedScene
@export var right_arm_model: PackedScene

@export_group("Text")
@export var name: String
@export var description: String

@export_group("Function")
@export var type: PartTypes
@export var stats: Array[StatModifier]
@export var behaviors: Array[PackedScene]
# @export var upgrade_1: BaseUpgrade
# @export var upgrade_2: BaseUpgrade
