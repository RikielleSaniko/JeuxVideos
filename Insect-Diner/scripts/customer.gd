extends Node2D
class_name Customer

signal left_queue(customer)
signal paid(amount, position)
signal left_angry

var leader : Node2D = null
var assigned_chair : Chair = null
var is_called : bool = false
var path_grid : PathGrid = null
var path : Array = []
var is_waiting_for_dish : bool = false
var is_served : bool = false
var price : int = 10
var exit_position : Vector2 = Vector2.ZERO
var original_parent : Node = null
var patience : float = 0.0


const ARRIVAL_DISTANCE = 2.0

@export var speed : float = 120.0
@export var favorite_dish : String = "honey_donuts"
@export var sprite_sheet : Texture2D
@export var dish_texture : Texture2D
@export var max_patience : float = 20.0


@onready var animated_sprite : AnimatedSprite2D = $AnimatedSprite2D
@onready var order_bubble : Sprite2D = $OrderBubble
@onready var dish_icon : Sprite2D = $OrderBubble/DishIcon
@onready var patience_bar : ProgressBar = $PatienceBar

var target : Vector2 = Vector2.ZERO

func _ready() -> void:
	if sprite_sheet:
		change_sprite_sheet(sprite_sheet)

func get_animated_sprite() -> AnimatedSprite2D:
	return animated_sprite

func move_to(point : Vector2, use_path : bool = true) -> void:
	target = point
	path = []

	if use_path and path_grid:
		var start : Vector2i = path_grid.get_closest_walkable_cell(global_position)
		var goal : Vector2i = path_grid.get_closest_walkable_cell(point)
		for cell in path_grid.find_path(start, goal):
			path.append(path_grid.cell_to_world(cell))

	path.append(point)


func walk_towards_target(delta : float) -> bool:
	if path.is_empty():
		return true

	var next_point : Vector2 = path[0]
	var direction : Vector2 = next_point - global_position
	
	if direction.length() < ARRIVAL_DISTANCE:
		global_position = next_point
		path.pop_front()
		return path.is_empty()
	
	if abs(direction.x) > abs(direction.y):
		if direction.x > 0:
			play_animation("walk_right")
		else:
			play_animation("walk_left")
	else:
		if direction.y > 0:
			play_animation("walk_down")
		else:
			play_animation("walk_up")
	
	global_position = global_position.move_toward(next_point, speed * delta)
	return false

func play_animation(anim_name : String, flipped : bool = false) -> void:
	animated_sprite.flip_h = flipped
	
	if !animated_sprite.sprite_frames.has_animation(anim_name):
		print("animation introuvable : ", anim_name) # AJOUTÉ
		return
	
	if animated_sprite.animation == anim_name and animated_sprite.is_playing():
		return
	
	animated_sprite.play(anim_name)

func change_sprite_sheet(new_sheet : Texture2D) -> void:
	var frames : SpriteFrames = animated_sprite.sprite_frames.duplicate()
	
	for anim_name in frames.get_animation_names():
		for i in frames.get_frame_count(anim_name):
			var frame = frames.get_frame_texture(anim_name, i).duplicate()
			frame.atlas = new_sheet
			frames.set_frame(anim_name, i, frame)
	
	animated_sprite.sprite_frames = frames

func interact(player) -> void:
	if is_waiting_for_dish:
		if player.carried_dish == favorite_dish:
			hide_order()
			hide_patience()
			is_waiting_for_dish = false
			is_served = true
			player.drop_dish()
		return

	if is_called or player.following_customer:
		return
	is_called = true
	leader = player
	player.following_customer = self

func can_interact(player) -> bool:
	if is_waiting_for_dish:
		return player.carried_dish != ""
	return !is_called

func assign_chair(chair : Chair) -> void:
	assigned_chair = chair
	chair.customer = self # la chaise est réservée a l'instant
	move_to(chair.get_seat_position())

func sit_on_chair() -> void:
	original_parent = get_parent()
	reparent(assigned_chair)
	global_position = assigned_chair.get_seat_position()
	show_behind_parent = assigned_chair.orientation == Chair.Facing.BACK
	show_seated(assigned_chair.orientation)
	show_order()
	reset_patience()

func show_seated(orientation : int) -> void:
	match orientation:
		Chair.Facing.FRONT:
			play_animation("sit_front")
		Chair.Facing.BACK:
			play_animation("sit_back")
		Chair.Facing.LEFT:
			play_animation("sit_side")
		Chair.Facing.RIGHT:
			play_animation("sit_side", true)

func show_order() -> void:
	dish_icon.texture = dish_texture
	order_bubble.visible = true
	is_waiting_for_dish = true

func hide_order() -> void:
	order_bubble.visible = false

func pay() -> void:
	paid.emit(price, global_position)

func stand_up() -> void:
	if !assigned_chair:
		return
	assigned_chair.customer = null
	reparent(original_parent)
	show_behind_parent = false
	assigned_chair = null

func reset_patience() -> void:
	patience = max_patience
	patience_bar.visible = true

func lose_patience(delta : float) -> bool:
	patience -= delta
	patience_bar.value = patience / max_patience * 100
	return patience <= 0

func hide_patience() -> void:
	patience_bar.visible = false
