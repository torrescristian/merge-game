extends Node2D

signal next_item_created
signal current_item_created
@onready var hook: Node2D = $Hook
var curr_hook: MergeItem
var is_loading = false
@onready var timer: Timer = $Timer

func _ready() -> void:
	load_item_in_hook()
	
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
