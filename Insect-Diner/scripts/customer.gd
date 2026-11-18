extends Node2D
class_name Customer

signal left_queue(customer)

var leader : Node2D = null
var assigned_chair : Chair = null
var is_called : bool = false
var path_grid : PathGrid = null
var path : Array = []

const ARRIVAL_DISTANCE = 2.0

@export var speed : float = 120.0
@export var favorite_dish : String = "honey_donuts"
@export var sprite_sheet : Texture2D

@onready var animated_sprite : AnimatedSprite2D = $AnimatedSprite2D

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
	if is_called or player.following_customer:
		return
	is_called = true
	leader = player
	player.following_customer = self

func assign_chair(chair : Chair) -> void:
	assigned_chair = chair
	chair.customer = self # la chaise est réservée a l'instant
	move_to(chair.get_seat_position())

func sit_on_chair() -> void:
	reparent(assigned_chair)
	global_position = assigned_chair.get_seat_position()
	show_behind_parent = assigned_chair.orientation == Chair.Facing.BACK
	show_seated(assigned_chair.orientation)

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
