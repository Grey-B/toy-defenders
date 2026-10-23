class_name EnemyDetection
extends Node

@export var tower: BaseTower

var candidates: Array[PathFollow3D]


func _on_area_3d_area_entered(area: Area3D) -> void:
	if area.get_parent() is BaseEnemy:
		if tower.attack_timer.is_stopped():
			tower.attack()
		candidates.append(area.get_parent())


func _on_area_3d_area_exited(area: Area3D) -> void:
	if area.get_parent() is BaseEnemy:
		candidates.pop_at(candidates.find(area.get_parent()))


func select_target() -> BaseEnemy:
	var best_target: BaseEnemy = null
	var furthest_progress: float = -1.0

	for enemy in candidates:
		if enemy.progress_ratio > furthest_progress:
			furthest_progress = enemy.progress_ratio
			best_target = enemy

	return best_target
