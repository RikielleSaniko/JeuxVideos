extends Control
class_name MainMenu

@onready var start_button : TextureButton = %StartButton
@onready var options_button : TextureButton = %OptionsButton
@onready var quit_button : TextureButton = %QuitButton

func _ready() -> void:
	start_button.pressed.connect(_on_start_pressed)
	options_button.pressed.connect(_on_options_pressed)
	quit_button.pressed.connect(_on_quit_pressed)

func _on_start_pressed() -> void:
	get_tree().change_scene_to_file("res://scenes/restaurant.tscn")

func _on_options_pressed() -> void:
	pass # Voir la section sur les options

func _on_quit_pressed() -> void:
	get_tree().quit()
