extends BaseState
class_name CustomerLeaving

@export var customer : Customer

var path : Array[Vector2] = []



func enter() -> void:
	customer.stand_up()
	customer.move_to(customer.exit_position)

func physics_update(delta : float) -> void:
	if customer.walk_towards_target(delta):
		customer.queue_free()
