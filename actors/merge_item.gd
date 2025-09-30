class_name MergeItem extends RigidBody2D
@onready var sprite_2d: Sprite2D = $Sprite2D
@onready var collision_shape_2d: CollisionShape2D = $CollisionShape2D
signal touched
var touched_emited := false

signal merged
signal collided
var is_merging := false


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
			return 3.0
		Autoload.PATRICIO:
			return 4.0
		Autoload.CALAMARDO:
			return 5.0
		Autoload.ARENITA:
			return 6.0


func _on_body_shape_entered(body_rid: RID, body: Node, body_shape_index: int, local_shape_index: int) -> void:
	if body is MergeItem:
		# Emitir señal de colisión para reproducir sonido
		collided.emit()
		
		# Solo el objeto con ID menor procesa el merge para evitar duplicados
		if get_instance_id() > body.get_instance_id():
			return
		
		# Verificar que ninguno de los objetos esté ya en proceso de merge
		if is_merging or body.is_merging:
			return
						
		if actor_index == body.actor_index:
			var isLastItem = actor_index == Autoload.ARENITA
			if (isLastItem):
				return
			
			# Marcar ambos objetos como en proceso de merge
			is_merging = true
			body.is_merging = true
			
			# Usar call_deferred para evitar errores de física
			call_deferred("_perform_merge", body)

func _perform_merge(other_body: MergeItem) -> void:
	# Crear el nuevo objeto antes de eliminar los existentes
	var mergeItem: MergeItem = preload("res://actors/merge_item.tscn").instantiate()
	mergeItem.position = Vector2(
		(position.x + other_body.position.x) / 2,
		(position.y + other_body.position.y) / 2,
	)
	mergeItem.actor_index = get_next_actor(actor_index)
	
	# Conectar las señales del nuevo objeto
	mergeItem.merged.connect(get_parent()._on_merge_item_merged)
	mergeItem.collided.connect(get_parent()._on_merge_item_collided)
	
	# Agregar el nuevo objeto al padre
	get_parent().add_child(mergeItem)
	
	# Eliminar ambos objetos originales
	other_body.queue_free()
	# Emitir la señal de merge para reproducir el sonido
	merged.emit()
	
	queue_free()
	
