extends Node2D

const MAX_WAITING = 4
var waiting_customers : Array[Customer] = []
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
@onready var path_grid : PathGrid = $PathGrid

var waiting_count : int = 0

func _on_customer_timer_timeout() -> void:
	if waiting_customers.size() >= MAX_WAITING:
		return

	var customer : Customer = CUSTOMER_SCENE.instantiate()
	var customer_type : Dictionary = CUSTOMER_TYPES.pick_random()
	
	customer.sprite_sheet = customer_type["sheet"]
	customer.favorite_dish = customer_type["dish"]
	customer.left_queue.connect(_on_customer_left_queue)
	customer.path_grid = path_grid
	
	furniture.add_child(customer)
	customer.global_position = entrance_point.global_position

	waiting_customers.append(customer)
	customer.move_to(get_waiting_position(waiting_customers.size() - 1))

func get_waiting_position(index : int) -> Vector2:
		return waiting_point.global_position + Vector2(index * WAITING_SPACING, 0)

#quand un client quitte la file, les suivant avancent
func _on_customer_left_queue(customer : Customer) -> void:
		waiting_customers.erase(customer)
		for i in waiting_customers.size():
			waiting_customers[i].move_to(get_waiting_position(i))
