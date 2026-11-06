extends BaseState
class_name CustomerWaiting

@export var customer : Customer

func enter() -> void:
	customer.play_animation("idle")