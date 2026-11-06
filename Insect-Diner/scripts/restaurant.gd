extends Node2D

const CUSTOMER_SCENE = preload("res://scenes/client.tscn")
const WAITING_SPACING = 70.0
const CUSTOMER_TYPES = [
	{
		"sheet": preload("res://assets/sprites/clients/fourmi_planche.png"),
		"dish": "honey_donuts",
	},
]

@onready var furniture : Node2D = $Furniture
@onready var entrance_point : Marker2D = $EntrancePoint
@onready var waiting_point : Marker2D = $WaitingPoint

var waiting_count : int = 0

func _on_customer_timer_timeout() -> void:
	var customer : Customer = CUSTOMER_SCENE.instantiate()
	var customer_type : Dictionary = CUSTOMER_TYPES.pick_random()
	
	customer.sprite_sheet = customer_type["sheet"]
	customer.favorite_dish = customer_type["dish"]
	
	furniture.add_child(customer)
	customer.global_position = entrance_point.global_position
	customer.move_to(waiting_point.global_position + Vector2(waiting_count * WAITING_SPACING, 0))
	waiting_count += 1