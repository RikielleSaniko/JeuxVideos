extends BaseState
class_name CustomerWaiting

@export var customer : Customer

func physics_update(delta : float) -> void:
	if customer.is_called:
		Transitioned.emit(self, "CustomerFollowing")
		return

	if customer.walk_towards_target(delta):
		customer.play_animation("idle")