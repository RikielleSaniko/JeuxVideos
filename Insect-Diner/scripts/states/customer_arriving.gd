extends BaseState
class_name CustomerArriving

@export var customer : Customer

func physics_update(delta : float) -> void:
	if customer.walk_towards_target(delta):
		Transitioned.emit(self, "CustomerWaiting")