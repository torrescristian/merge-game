extends Node2D

signal next_item_created
signal current_item_created
@onready var hook: Node2D = $Hook
var curr_hook: MergeItem
var is_loading = false
@onready var timer: Timer = $Timer
@onready var sfx: AudioStreamPlayer = $SFXAudioStreamPlayer
@onready var collision_audio_player: AudioStreamPlayer = $CollisionAudioPlayer
const item_merged_sound = preload("res://assets/sounds/168290__wuola__balloon-23.wav")
const item_collied_sound = preload("res://assets/sounds/789792__quatricise__pop-3.wav")

# Sistema de throttling para colisiones
const COLLISION_THROTTLE_TIME: float = 0.15 # 150ms entre colisiones
var collision_timer: Timer

func _ready() -> void:
	load_item_in_hook()
	
	# Configurar cursor por defecto
	Input.set_custom_mouse_cursor(null, Input.CURSOR_ARROW)
	
	# Configurar timer para throttling de colisiones
	collision_timer = Timer.new()
	collision_timer.wait_time = COLLISION_THROTTLE_TIME
	collision_timer.one_shot = true
	add_child(collision_timer)

func _input(event: InputEvent) -> void:
	# Forzar mouse visible en cada input
	Input.mouse_mode = Input.MOUSE_MODE_VISIBLE

func _physics_process(_delta: float) -> void:
	# Forzar mouse visible en cada frame
	Input.mouse_mode = Input.MOUSE_MODE_VISIBLE
	
	if Input.is_action_just_pressed("create_arenita"):
		Autoload.current_item = Autoload.BOB_ESPONJA
		if (curr_hook):
			curr_hook.actor_index = Autoload.BOB_ESPONJA
	if Input.is_action_just_pressed("create_calamardo"):
		Autoload.current_item = Autoload.CALAMARDO
		if (curr_hook):
			curr_hook.actor_index = Autoload.CALAMARDO
	
	
func _on_area_2d_input_event(_viewport: Node, event: InputEvent, _shape_idx: int) -> void:
	if event is InputEventMouseButton and event.pressed and event.button_index == MOUSE_BUTTON_LEFT:
		if get_viewport_rect().has_point(event.position):
			if !timer.is_stopped():
				return
			
			release_item_from_hook()
			timer.start()

func create_merge_item() -> MergeItem:
	var mergeItem: MergeItem = preload("res://actors/merge_item.tscn").instantiate()
	mergeItem.position = hook.position
	mergeItem.actor_index = Autoload.current_item
	return mergeItem

func load_item_in_hook():
	var mergeItem = create_merge_item()
	mergeItem.gravity_scale = 0
	mergeItem.position = hook.to_local(hook.global_position)
	hook.add_child(mergeItem)
	curr_hook = mergeItem

func load_item_in_level_1():
	var mergeItem = create_merge_item()
	mergeItem.merged.connect(_on_merge_item_merged)
	mergeItem.collided.connect(_on_merge_item_collided)
	add_child(mergeItem)

func release_item_from_hook():
	load_item_in_level_1()
	curr_hook.queue_free();

func update_next_and_current_items():
	var next_item = Autoload.get_random_actor()
	Autoload.current_item = Autoload.next_item
	Autoload.next_item = next_item
	
	current_item_created.emit(Autoload.current_item)
	next_item_created.emit(next_item)


func _on_timer_timeout() -> void:
	update_next_and_current_items()
	load_item_in_hook()

func _on_merge_item_merged() -> void:
	# El sonido de merge tiene máxima prioridad
	sfx.stop()
	collision_audio_player.stop()
	sfx.stream = item_merged_sound
	sfx.volume_db = 10.0
	sfx.play()

func _on_merge_item_collided() -> void:
	# Solo reproducir si no hay un sonido de merge reproduciéndose y el timer no está activo
	if not sfx.playing and collision_timer.is_stopped():
		collision_audio_player.stop()
		collision_audio_player.stream = item_collied_sound
		collision_audio_player.volume_db = -5.0 # Más bajo que el merge
		collision_audio_player.play()
		
		# Iniciar el timer de throttling
		collision_timer.start()
