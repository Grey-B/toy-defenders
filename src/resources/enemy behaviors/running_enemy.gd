class_name RunningEnemy
extends AbstractBehavior

var contact_damage: int = 10
var lerp_value: float = 0.15


func process_behavior(enemy: BaseEnemy, player: Player) -> void:
	var direction := enemy.global_position.direction_to(player.global_position)
	if direction:
		enemy.look_at(player.global_position)
		#lerp_angle(
		#enemy.model_instance.rotation.y,
		#atan2(enemy.velocity.x, enemy.velocity.z),
		#lerp_value,
		#)

		enemy.velocity.x = direction.x * enemy.speed
		enemy.velocity.z = direction.z * enemy.speed

	enemy.move_and_slide()
