extends Node2D

const MAX_WAITING = 4
var waiting_customers : Array[Customer] = []
const CUSTOMER_SCENE = preload("res://scenes/client.tscn")
const FLOATING_TEXT_SCENE = preload("res://scenes/floating_text.tscn")
const WAITING_SPACING = 70.0
const CUSTOMER_TYPES = [
	{
		"sheet": preload("res://assets/sprites/clients/fourmi_planche.png"),
		"dish": "honey_donuts",
		"dish_texture": preload("res://assets/sprites/beignets_miel_3.png")
	},
]

@onready var furniture : Node2D = $Furniture
@onready var entrance_point : Marker2D = $EntrancePoint
@onready var waiting_point : Marker2D = $WaitingPoint
@onready var path_grid : PathGrid = $PathGrid
@onready var money_label : Label = $HUD/MoneyLabel

var waiting_count : int = 0
var money : int = 0

func _ready() -> void:
	update_hud()

func _on_customer_timer_timeout() -> void:
	if waiting_customers.size() >= MAX_WAITING:
		return

	var customer : Customer = CUSTOMER_SCENE.instantiate()
	var customer_type : Dictionary = CUSTOMER_TYPES.pick_random()
	
	customer.sprite_sheet = customer_type["sheet"]
	customer.favorite_dish = customer_type["dish"]
	customer.dish_texture = customer_type["dish_texture"]
	customer.left_queue.connect(_on_customer_left_queue)
	customer.paid.connect(_on_customer_paid)
	customer.path_grid = path_grid
	customer.exit_position = entrance_point.global_position

	furniture.add_child(customer)
	customer.global_position = entrance_point.global_position

	waiting_customers.append(customer)
	customer.move_to(get_waiting_position(waiting_customers.size() - 1))

func get_waiting_position(index : int) -> Vector2:
	return waiting_point.global_position + Vector2(index * WAITING_SPACING, 0)

func _on_customer_left_queue(customer : Customer) -> void:
	waiting_customers.erase(customer)
	for i in waiting_customers.size():
		waiting_customers[i].move_to(get_waiting_position(i))

func _on_customer_paid(amount : int, customer_position : Vector2) -> void:
	money += amount
	update_hud()

	var floating_text : FloatingText = FLOATING_TEXT_SCENE.instantiate()
	floating_text.text = "+" + str(amount)
	floating_text.position = customer_position + Vector2(-20, -120)
	add_child(floating_text)

func update_hud() -> void:
	money_label.text = "Argent : " + str(money)
