extends BaseState
class_name CustomerSeated

@export var customer : Customer

func enter() -> void:
	customer.sit_on_chair()