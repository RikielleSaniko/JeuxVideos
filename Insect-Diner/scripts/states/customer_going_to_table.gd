extends BaseState
class_name CustomerGoingToTable

@export var customer : Customer

func physics_update(delta : float) -> void:
	if customer.walk_towards_target(delta):
		Transitioned.emit(self, "CustomerSeated")