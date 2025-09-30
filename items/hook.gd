extends Node2D

func _input(event: InputEvent) -> void:
	if event is InputEventMouseMotion:
		position = Vector2(
			clamp(event.position.x, 120, 540),
			position.y,
		)
		
		for child in get_children():
			if child is MergeItem:
				child.position = to_local(position)
