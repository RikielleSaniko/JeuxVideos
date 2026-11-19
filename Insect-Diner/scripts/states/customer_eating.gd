extends BaseState

class_name CustomerEating

const EAT_TIME : float = 4.0

@export var customer : Customer
var time_left : float = 0.0

func enter() -> void:
	if customer.assign_chair.orientation == Chair.Facing.FRONT;
		customer.play_animation("eat")
	time_left = EAT_TIME

func physics_update(delta: float) -> void:
	time_left -= delta
	if time_left <= 0:
		customer.pay()
		Transitioned.emit(self, "CustomerLeaving")
