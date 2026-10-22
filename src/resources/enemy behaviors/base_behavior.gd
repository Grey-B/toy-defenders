class_name BaseBehavior
extends AbstractBehavior

func process_behavior(delta: float, enemy: BaseEnemy) -> void:
	enemy.progress += delta * enemy.speed
	if enemy.progress_ratio >= 1.0:
		enemy.deal_damage()
