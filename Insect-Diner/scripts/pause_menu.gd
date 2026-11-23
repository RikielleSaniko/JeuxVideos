extends CanvasLayer

const MENU_SCENE : String = "res://scenes/menu_principal.tscn"

@onready var resume_button : TextureButton = %ResumeButton
@onready var menu_button : TextureButton = %MenuButton


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	visible = false
	resume_button.pressed.connect(_on_resume_button_pressed)
	menu_button.pressed.connect(_on_menu_button_pressed)

func _unhandled_input(event: InputEvent) -> void:
	if event.is_action_pressed("pause"):
		toggle_pause()

func toggle_pause() -> void:
	get_tree().paused = !get_tree().paused
	visible = get_tree().paused
	if get_tree().paused:
		resume_button.grab_focus()

func _on_resume_button_pressed() -> void:
	toggle_pause()

func _on_menu_button_pressed() -> void:
	get_tree().paused = false 
	get_tree().change_scene_to_file(MENU_SCENE)
