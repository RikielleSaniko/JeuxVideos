extends Node2D

const MAX_WAITING = 4
const MAX_LOST_CUSTOMERS = 3
var waiting_customers : Array[Customer] = []
var level : Dictionary = {}
var time_left : float = 0.0
var is_day_over = false
const CUSTOMER_SCENE = preload("res://scenes/client.tscn")
const FLOATING_TEXT_SCENE = preload("res://scenes/floating_text.tscn")
const END_SCENE : String = "res://scenes/end_screen.tscn"
const WAITING_SPACING = 70.0

const CUSTOMER_TYPES = {

	"ant": {
		"sheet": preload("res://assets/sprites/clients/fourmi_planche.png"),
		"dish": "honey_donuts",
		"dish_texture": preload("res://assets/sprites/beignets_miel_3.png")
	},	
}

@onready var furniture : Node2D = $Furniture
@onready var entrance_point : Marker2D = $EntrancePoint
@onready var waiting_point : Marker2D = $WaitingPoint
@onready var path_grid : PathGrid = $PathGrid
@onready var money_label : Label = $HUD/HudPanel/VBoxContainer/MoneyLabel
@onready var lost_label : Label = $HUD/HudPanel/VBoxContainer/LostLabel
@onready var time_label : Label = $HUD/HudPanel/VBoxContainer/TimeLabel
@onready var customer_timer : Timer = $CustomerTimer
@onready var level_label : Label = $HUD/HudPanel/VBoxContainer/LevelLabel

var waiting_count : int = 0
var money : int = 0
var lost_customers : int = 0

func _ready() -> void:
	level = GameState.get_level()
	time_left = level["duration"]
	customer_timer.wait_time = level["spawn_time"]
	update_hud()

func _process(delta : float) -> void:
	if is_day_over:
		return
	time_left -= delta
	update_hud()
	if time_left <= 0:
		end_day(money >= level["goal"])

func _on_customer_timer_timeout() -> void:
	if waiting_customers.size() >= MAX_WAITING:
		return

	var customer : Customer = CUSTOMER_SCENE.instantiate()
	var customer_name : String = level["customers"].pick_random()
	var customer_type : Dictionary = CUSTOMER_TYPES[customer_name]
	
	customer.sprite_sheet = customer_type["sheet"]
	customer.favorite_dish = customer_type["dish"]
	customer.dish_texture = customer_type["dish_texture"]
	customer.left_queue.connect(_on_customer_left_queue)
	customer.paid.connect(_on_customer_paid)
	customer.path_grid = path_grid
	customer.exit_position = entrance_point.global_position
	customer.left_angry.connect(_on_customer_left_angry)
	customer.max_patience = level["patience"]

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

func _on_customer_left_angry() -> void:
	lost_customers += 1
	update_hud()
	if lost_customers >= MAX_LOST_CUSTOMERS:
		end_day(false)

func update_hud() -> void:
	money_label.text = "Argent : %d / %d $" % [money, level["goal"]]

	var minutes : int = int(time_left) / 60
	var seconds : int = int(time_left) % 60

	lost_label.text = "Clients perdus : %d / %d" % [lost_customers, MAX_LOST_CUSTOMERS]
	time_label.text = "Temps : %d:%02d" % [minutes, seconds]

	level_label.text = "Niveau %d" % (GameState.current_level + 1)

func end_day(won : bool) -> void:
	if is_day_over:
		return
	is_day_over = true
	customer_timer.stop()
	GameState.last_won = won
	GameState.last_money = money
	get_tree().change_scene_to_file(END_SCENE)

func _unhandled_input(event: InputEvent) -> void:
	if event.is_action_pressed("end_game"):
		end_day(money >= level["goal"])
