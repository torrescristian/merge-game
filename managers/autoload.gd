extends Node

const PLANCTON = "PLANCTON"
const GARY = "GARY"
const BOB_ESPONJA = "BOB_ESPONJA"
const PATRICIO = "PATRICIO"
const CALAMARDO = "CALAMARDO"
const ARENITA = "ARENITA"
const SCALE_BASE: float = 0.07

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
