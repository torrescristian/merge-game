extends Panel
@onready var sfxh_slider: HSlider = $VBoxContainer/SFXHBoxContainer/SFXHSlider
@onready var music_h_slider: HSlider = $VBoxContainer/MusicHBoxContainer/MusicHSlider

func _ready() -> void:
	get_tree().paused = true
	Input.mouse_mode = Input.MOUSE_MODE_VISIBLE
	
	music_h_slider.value = Autoload.config_music
	sfxh_slider.value = Autoload.config_sfx

func _on_close_button_pressed() -> void:
	get_tree().paused = false
	queue_free()


func _on_music_h_slider_value_changed(value: float) -> void:
	Autoload.change_music_volume(value)


func _on_sfxh_slider_value_changed(value: float) -> void:
	Autoload.change_sfx_volume(value)
