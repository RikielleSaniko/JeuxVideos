class_name PlayerRoll
extends BaseState

@export var player : Player
@export var roll_speed : float = 300.0
var animated_sprite : AnimatedSprite2D
@export var roll_friction : float = 700.0
var dir : float = 0.0
var direction_roll := 1

func enter():
	animated_sprite = player.get_animated_sprite()
	
	if animated_sprite.flip_h:
		direction_roll = -1
	else: 
		direction_roll = 1
	player.velocity.x = roll_speed * direction_roll
	
	animated_sprite.play("roll")
	print("roll")
	
func _input(event: InputEvent) -> void:
	handle_inputs(event)

func handle_inputs(input_event: InputEvent) -> void :
	dir = Input.get_axis("ui_left", "ui_right")
	
func physics_update(delta: float) -> void:
	if not animated_sprite : return
	player.velocity.x = move_toward(player.velocity.x, 0.0, roll_friction * delta)
	
	if player.velocity.x == 0:
		if dir != 0: 
			Transitioned.emit(self, "PlayerRun")
		else: 
			Transitioned.emit(self, "PlayerIdle")
		
func exit() -> void:
	player.velocity.x = 0
