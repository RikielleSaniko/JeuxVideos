extends BaseState
class_name CustomerWaiting

@export var customer : Customer

#la patience commence au maximum quand le client arrive dans la file
func enter() -> void:
	customer.reset_patience()

func physics_update(delta : float) -> void:
	if customer.is_called:
		Transitioned.emit(self, "CustomerFollowing")
		return

	if customer.lose_patience(delta):
		Transitioned.emit(self, "CustomerAngry")
		return

	if customer.walk_towards_target(delta):
		customer.play_animation("idle")

# cacher la barre en quiitant la file
func exit() -> void:
	customer.hide_patience()
