class_name PlayerRun
extends BaseState

@export var player : Player
var animated_sprite : AnimatedSprite2D
var dir : float = 0.0
@export var move_speed : float = 300.0

func enter():
	animated_sprite = player.get_animated_sprite()
	animated_sprite.play("run")
	print("run")
	
func _input(event: InputEvent) -> void:
	handle_inputs(event)

func handle_inputs(input_event: InputEvent) -> void :
	dir = Input.get_axis("ui_left", "ui_right")
	
	if Input.is_action_just_pressed("jump") and player.is_on_floor() :
		Transitioned.emit(self, "PlayerJump")
		
	if Input.is_action_just_pressed("roll") :
		Transitioned.emit(self, "PlayerRoll")

func physics_update(delta: float) -> void:
	if not animated_sprite : return
	
	if dir:
		player.velocity.x = dir * move_speed
		animated_sprite.flip_h = dir < 0
		
	else:
		player.velocity.x = move_toward(player.velocity.x, 0.0, move_speed)
	
	if player.velocity.x == 0:
		Transitioned.emit(self, "PlayerIdle")

func exit() -> void:
	player.velocity.x = 0
	
