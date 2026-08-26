extends RigidBody2D
class_name DraggablePhysicsBody2D
#@export is the same thing as public as Unity
@export var throw_force_multiplier: float = 1.0  
@export var max_throw_speed: float = 2000.0      
@export var drag_smoothness: float = 12.0   ## higher = snappier/tighter follow, lower = smoother/laggier
 
var _dragging: bool = false
var _drag_offset: Vector2 = Vector2.ZERO
var _last_position: Vector2 = Vector2.ZERO
var _current_velocity: Vector2 = Vector2.ZERO
var _cached_gravity_scale: float = 1.0
 
func _ready() -> void:
	input_pickable = true
	input_event.connect(_on_input_event)
	_cached_gravity_scale = gravity_scale
 
func _on_input_event(_viewport: Node, event: InputEvent, _shape_idx: int) -> void:
	if event is InputEventMouseButton and event.button_index == MOUSE_BUTTON_LEFT and event.pressed:
		_start_drag()
 
# Listen globally for release so letting go off-body still ends the drag.
func _input(event: InputEvent) -> void:
	if _dragging and event is InputEventMouseButton:
		if event.button_index == MOUSE_BUTTON_LEFT and not event.pressed:
			_end_drag()
 
func _start_drag() -> void:
	_dragging = true
	_drag_offset = global_position - get_global_mouse_position()
	
	#halts movement
	linear_velocity = Vector2.ZERO
	angular_velocity = 0.0
	freeze = true  # suspends gravity + physics response while held
	_last_position = global_position
 
func _physics_process(delta: float) -> void:
	if not _dragging:
		return
	var target_pos: Vector2 = get_global_mouse_position() + _drag_offset
 
	#`drag_smoothness controls how tight the follow is (higher = snappier).
	var t: float = 1.0 - exp(-drag_smoothness * delta)
	var new_pos: Vector2 = global_position.lerp(target_pos, t)
 
	if delta > 0.0:
		_current_velocity = (new_pos - _last_position) / delta
	global_position = new_pos
	_last_position = new_pos
 
func _end_drag() -> void:
	_dragging = false
	freeze = false
	gravity_scale = _cached_gravity_scale
	var throw_velocity: Vector2 = _current_velocity * throw_force_multiplier
	if throw_velocity.length() > max_throw_speed:
		throw_velocity = throw_velocity.normalized() * max_throw_speed
	linear_velocity = throw_velocity
