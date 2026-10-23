class_name StatModifier
extends Resource

enum Stat { DAMAGE, ATTACK_SPD, RANGE, PIERCE }
enum Operation { ADD, MULTIPLY }

@export var stat: Stat
@export var operation: Operation
@export var value: float = 1.0
