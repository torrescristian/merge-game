extends Node2D
const level_1_scene = "res://scenes/level_1.tscn"

func _ready():
	Input.mouse_mode = Input.MOUSE_MODE_VISIBLE

func _input(event: InputEvent) -> void:
	# Forzar mouse visible en cada frame
	Input.mouse_mode = Input.MOUSE_MODE_VISIBLE
	
	# Permitir usar Enter o Espacio para iniciar el juego
	if event is InputEventKey and event.pressed:
		if event.keycode == KEY_ENTER or event.keycode == KEY_SPACE:
			print("=== KEYBOARD START PRESSED ===")
			_on_start_button_pressed()
		elif event.keycode == KEY_ESCAPE:
			print("=== KEYBOARD EXIT PRESSED ===")
			_on_exit_button_pressed()

func _on_start_button_pressed() -> void:
	Autoload.change_scene(level_1_scene)

func _on_exit_button_pressed() -> void:
	get_tree().quit()
