extends Control
class_name  EndScreen

const GAME_SCENE : String = "res://scenes/restaurant.tscn"
const MENU_SCENE : String = "res://scenes/menu_principal.tscn"

const GOLD : Color = Color("ffd23f")
const RED : Color = Color("e04848")

@onready var title_label : Label = %TitleLabel
@onready var message_label : Label = %MessageLabel
@onready var next_level_button : TextureButton = %NextLevelButton
@onready var restart_button : TextureButton = %RestartButton
@onready var menu_button : TextureButton = %MenuButton
@onready var quit_button : TextureButton = %QuitButton


func _ready() -> void:
	next_level_button.pressed.connect(_on_next_level_button_pressed)
	restart_button.pressed.connect(_on_restart_button_pressed)
	menu_button.pressed.connect(_on_menu_button_pressed)
	quit_button.pressed.connect(_on_quit_button_pressed)

	if GameState.last_won:
		if GameState.is_last_level():
			title_label.text = "Victoire !"
		else:
			title_label.text = "Journée réussie !"
		title_label.add_theme_color_override("font_color", GOLD)
	else:
		title_label.text = "Défaite... "
	title_label.add_theme_color_override("font_color", RED)

	message_label.text = "Argent gagné : %d / %d $" % [GameState.last_money, GameState.get_level()["goal"]]
	next_level_button.visible = GameState.last_won and !GameState.is_last_level()

	if next_level_button.visible:
		next_level_button.grab_focus()
	else:
		restart_button.grab_focus()
	print("end screen ready")

func _on_next_level_button_pressed() -> void:
	GameState.current_level += 1
	get_tree().change_scene_to_file(GAME_SCENE)

func _on_restart_button_pressed() -> void:
	print("restart pressed")
	GameState.current_level = 0 
	get_tree().change_scene_to_file(GAME_SCENE)

func _on_menu_button_pressed() -> void:
	get_tree().change_scene_to_file(MENU_SCENE)

func _on_quit_button_pressed() -> void:
	get_tree().quit()
