extends Node

const PLANCTON = "PLANCTON"
const GARY = "GARY"
const BOB_ESPONJA = "BOB_ESPONJA"
const PATRICIO = "PATRICIO"
const CALAMARDO = "CALAMARDO"
const ARENITA = "ARENITA"
const SCALE_BASE: float = 0.07

var config_music = 0
var config_sfx = 0

func change_sfx_volume(new_volume: float):
	config_sfx = new_volume
	var sfx_audio_stream_player: AudioStreamPlayer = get_tree().get_first_node_in_group("SFX")
	var collision_audio_stream_player: AudioStreamPlayer = get_tree().get_first_node_in_group("Collision")
		
	sfx_audio_stream_player.volume_db = new_volume + 10.0
	collision_audio_stream_player.volume_db = new_volume - 5.0

func change_music_volume(new_volume: float):
	config_music = new_volume
	var music_audio_stream_player: AudioStreamPlayer = get_tree().get_first_node_in_group("Music")
	
	music_audio_stream_player.volume_db = new_volume - 25.0

func _input(event: InputEvent) -> void:
	# Asegurar que el mouse siempre esté visible - más agresivo
	Input.mouse_mode = Input.MOUSE_MODE_VISIBLE
	
	if event is InputEventKey and Input.is_action_just_pressed("ui_cancel"):
		var level = get_tree().get_first_node_in_group("Level")
		var option = get_tree().get_first_node_in_group("Option")
		if (level != null and option == null):
			level.add_child(preload("res://ui/Options/options.tscn").instantiate())


func get_random_actor() -> String:
	var actors_arr = [PLANCTON, GARY, BOB_ESPONJA, PATRICIO]
	var res = actors_arr.pick_random()
	return res

var next_item = GARY
var current_item = PLANCTON

func texture_by_actor(actor_index: String):
	match actor_index:
		Autoload.BOB_ESPONJA:
			return 0
		Autoload.PATRICIO:
			return 1
		Autoload.PLANCTON:
			return 2
		Autoload.CALAMARDO:
			return 3
		Autoload.ARENITA:
			return 4
		Autoload.GARY:
			return 5

func scale_by_actor(actor_index: String) -> float:
	match actor_index:
		Autoload.PLANCTON:
			return 1.0
		Autoload.GARY:
			return 2.0
		Autoload.BOB_ESPONJA:
			return 2.5
		Autoload.PATRICIO:
			return 3.0
		Autoload.CALAMARDO:
			return 5.0
		Autoload.ARENITA:
			return 8.0
		_:
			return 1.0

func position_by_actor(actor_index: String):
	match actor_index:
		Autoload.PLANCTON:
			return Vector2(10.0, -32.0)
		Autoload.GARY:
			return Vector2(-10.0, 31.0)
		Autoload.BOB_ESPONJA:
			return Vector2(12.0, -32.0)
		Autoload.PATRICIO:
			return Vector2(-3.0, -34.0)
		Autoload.CALAMARDO:
			return Vector2(10.0, 29.0)
		Autoload.ARENITA:
			return Vector2(-3.0, 31.0)

func scale_actor(sprite_2d: Sprite2D, collision_shape_2d: CollisionShape2D, actor_index: String):
	var newScale = Vector2(
		Autoload.SCALE_BASE * Autoload.scale_by_actor(actor_index),
		Autoload.SCALE_BASE * Autoload.scale_by_actor(actor_index),
	)
	sprite_2d.frame = Autoload.texture_by_actor(actor_index)
	sprite_2d.apply_scale(newScale)
	collision_shape_2d.apply_scale(newScale)
	
	  # Ahora ajustamos la posición del sprite con el offset, pero escalado
	var offset = position_by_actor(actor_index)
	sprite_2d.position = offset * newScale

func change_scene(new_scene):
	get_tree().change_scene_to_file(new_scene)
	# Asegurar que el mouse sea visible después del cambio de escena
	call_deferred("_ensure_mouse_visible")

func _ensure_mouse_visible():
	Input.mouse_mode = Input.MOUSE_MODE_VISIBLE
