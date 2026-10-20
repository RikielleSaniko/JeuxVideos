class_name PlayerJump
extends BaseState

@export var player : Player
var animated_sprite : AnimatedSprite2D
const JUMP_VELOCITY = -400.0

func enter():
	animated_sprite = player.get_animated_sprite()
	player.velocity.y = JUMP_VELOCITY
	print("jump")
	

func _input(event: InputEvent) -> void:
	handle_inputs(event)

func handle_inputs(input_event: InputEvent) -> void :
	var dir := Input.get_axis("ui_left", "ui_right")
	if not dir == 0:
		Transitioned.emit(self, "PlayerRun")
	
func physics_update(delta: float) -> void:
	if not animated_sprite : return
	
	if player.velocity.y == 0 and player.is_on_floor():
		Transitioned.emit(self, "PlayerIdle")
	
	
func exit() -> void:
	pass
