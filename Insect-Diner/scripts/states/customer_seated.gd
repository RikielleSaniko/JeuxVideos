extends BaseState
class_name CustomerSeated

@export var customer : Customer

func enter() -> void:
	customer.sit_on_chair.call_deferred()

func physics_update(delta: float) -> void:
	if customer.is_served:
		Transitioned.emit(self, "CustomerEating")
