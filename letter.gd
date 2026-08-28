extends DraggablePhysicsBody2D
class_name LetterTile


@export var letter: String = "A"
@export var clicks_to_dislodge: int = 3
@export var snap_distance: float = 60.0
@export var start_menu_parent : Node2D

signal picked_up
signal placed_in_slot(slot: LetterSlot)
signal dislodged  ## fired the moment it breaks loose and starts falling
signal landed     ## fired once real physics settles it on the floor

## three tier state machine for letters, 
enum TileState { LOCKED, FALLING, FREE }

var current_slot: LetterSlot = null
var _state: TileState = TileState.LOCKED
var _click_count: int = 0

func _ready() -> void:
	super._ready()  # sets input_pickable, connects input_event, caches gravity_scale
	freeze = true   # locked/embedded — no physics simulation yet
	sleeping_state_changed.connect(_on_sleeping_state_changed)
	start_menu_parent = get_tree().current_scene

func _on_input_event(viewport: Node, event: InputEvent, shape_idx: int) -> void:
	match _state:
		TileState.LOCKED:
			if event is InputEventMouseButton and event.button_index == MOUSE_BUTTON_LEFT and event.pressed:
				_register_click()
		TileState.FALLING:
			pass  # ignore input mid-fall
		TileState.FREE:
			super._on_input_event(viewport, event, shape_idx)  # normal drag-start
			
##once letters drop, reparent them to the scene
func _reparent_out_of_popup() -> void:
	var new_parent = start_menu_parent
	if new_parent == null:
		push_warning("new parent not found")
		return
	if new_parent == get_parent():
		return  # already there
 
	
	var saved_global_pos: Vector2 = global_position
	var saved_rotation: float = rotation
	var saved_velocity: Vector2 = linear_velocity
 
	get_parent().remove_child(self)
	new_parent.add_child(self)
 
	global_position = saved_global_pos
	rotation = saved_rotation
	linear_velocity = saved_velocity
	
func _register_click() -> void:
	_click_count += 1
	if _click_count >= clicks_to_dislodge:
		_start_falling()

func _start_falling() -> void:
	_state = TileState.FALLING
	freeze = false  # hand control to real gravity/collision
	call_deferred("_reparent_out_of_popup")
	dislodged.emit()

func _on_sleeping_state_changed() -> void:
	if _state == TileState.FALLING and sleeping:
		_state = TileState.FREE
		landed.emit()

func _start_drag() -> void:
	if current_slot:
		current_slot.current_tile = null
		current_slot = null
	picked_up.emit()
	super._start_drag()

func _end_drag() -> void:
	super._end_drag()  # restores physics + applies throw velocity
	var nearest_slot: LetterSlot = _find_nearest_open_slot()
	if nearest_slot:
		_snap_to_slot(nearest_slot)

func _find_nearest_open_slot() -> LetterSlot:
	var best: LetterSlot = null
	var best_dist: float = snap_distance
	for slot in get_tree().get_nodes_in_group("letter_slots"):
		if slot.current_tile != null:
			continue
		var d: float = global_position.distance_to(slot.global_position)
		if d < best_dist:
			best_dist = d
			best = slot
	return best

func _snap_to_slot(slot: LetterSlot) -> void:
	global_position = slot.global_position
	freeze = true  # lock in place so other falling/dragged letters can't bump it loose
	slot.current_tile = self
	current_slot = slot
	placed_in_slot.emit(slot)
