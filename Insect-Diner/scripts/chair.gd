extends Sprite2D
class_name Chair 

enum Facing {FRONT, BACK, LEFT, RIGHT}

@export var orientation : Facing = Facing.FRONT
@onready var seat : Marker2D = $Seat

var customer : Customer = null

func is_free() -> bool:
	return customer == null

func get_seat_position() -> Vector2:
	return seat.global_position

