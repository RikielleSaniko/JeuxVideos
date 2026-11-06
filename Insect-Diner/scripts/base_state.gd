extends Node

class_name BaseState

signal 	Transitioned

func handle_inputs(_input_event: InputEvent) -> void:
	pass

func update(_delta: float) -> void:
	pass

func physics_update(_delta: float) -> void:
	pass

func enter() -> void:
	pass

func exit() -> void:
	pass