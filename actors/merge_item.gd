class_name MergeItem extends RigidBody2D

@onready var sprite_2d: Sprite2D = $Sprite2D
@onready var collision_shape_2d: CollisionShape2D = $CollisionShape2D
signal touched
var touched_emited := false


@export_enum(Autoload.BOB_ESPONJA, Autoload.PATRICIO, Autoload.PLANCTON, Autoload.CALAMARDO, Autoload.ARENITA, Autoload.GARY) var actor_index: String

func _ready() -> void:
	Autoload.scale_actor(
		sprite_2d,
		collision_shape_2d,
		actor_index
	)

func get_next_actor(curr_actor: String):
	match curr_actor:
		Autoload.PLANCTON:
			return Autoload.GARY
		Autoload.GARY:
			return Autoload.BOB_ESPONJA
		Autoload.BOB_ESPONJA:
			return Autoload.PATRICIO
		Autoload.PATRICIO:
			return Autoload.CALAMARDO
		Autoload.CALAMARDO:
			return Autoload.ARENITA
		Autoload.ARENITA:
			return Autoload.ARENITA
		
func scale_by_actor():
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


func _on_body_shape_entered(body_rid: RID, body: Node, body_shape_index: int, local_shape_index: int) -> void:
	if body is MergeItem:
		# Solo el objeto con ID menor procesa el merge para evitar duplicados
		if get_instance_id() > body.get_instance_id():
			return
						
		if actor_index == body.actor_index:
			var isLastItem = actor_index == Autoload.ARENITA
			if (isLastItem):
				return
			
			# Crear el nuevo objeto antes de eliminar los existentes
			var mergeItem: MergeItem = preload("res://actors/merge_item.tscn").instantiate()
			mergeItem.position = Vector2(
				(position.x + body.position.x) / 2,
				(position.y + body.position.y) / 2,
			)
			mergeItem.actor_index = get_next_actor(actor_index)
			
			# Agregar el nuevo objeto al padre
			get_parent().add_child(mergeItem)
			
			# Eliminar ambos objetos originales
			body.queue_free()
			queue_free()
