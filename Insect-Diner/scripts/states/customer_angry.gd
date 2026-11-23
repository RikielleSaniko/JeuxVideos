extends BaseState
class_name CustomerAngry 

const ANGRY_TIME : float = 1.5

@export var customer : Customer

var time_left : float = 0.0

func enter() -> void:
	customer.hide_order()
	customer.hide_patience()
	customer.play_animation("angry")
	print(customer.animated_sprite.sprite_frames.get_animation_names())
	customer.left_angry.emit()

	if !customer.is_called:
		customer.left_queue.emit(customer)

	time_left = ANGRY_TIME

func physics_update(delta : float) -> void:
	time_left -= delta
	if time_left <= 0:
		Transitioned.emit(self, "CustomerLeaving")