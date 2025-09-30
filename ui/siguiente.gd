extends Node2D
@onready var sprite_2d: Sprite2D = $Sprite2D

func _on_level_1_next_item_created(next_item) -> void:
	sprite_2d.frame = Autoload.texture_by_actor(next_item)
