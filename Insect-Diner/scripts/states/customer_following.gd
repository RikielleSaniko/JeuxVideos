extends BaseState
class_name CustomerFollowing

const FOLLOW_DISTANCE = 60.0

@export var customer : Customer

func enter() -> void:
	customer.left_queue.emit(customer)

func physics_update(delta: float) -> void:
	if customer.assigned_chair :
		Transitioned.emit(self, "CustomerGoingToTable")
		return

	customer.move_to(customer.leader.global_position, false)
	if customer.global_position.distance_to(customer.leader.global_position) > FOLLOW_DISTANCE :
		customer.walk_towards_target(delta)
	else:
		customer.play_animation("idle")
