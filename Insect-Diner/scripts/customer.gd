extends Node2D
class_name Customer

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

func move_to(point : Vector2) -> void:
	target = point

func walk_towards_target(delta : float) -> bool:
	var direction : Vector2 = target - global_position
	
	if direction.length() < ARRIVAL_DISTANCE:
		global_position = target
		return true
	
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
	
	global_position = global_position.move_toward(target, speed * delta)
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
