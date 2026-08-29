extends Node2D


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	erase_input("jump", KEY_SPACE)
	erase_input("move_left", KEY_A)
	erase_input("move_right", KEY_D)

func erase_input(action: String, key: Key) -> void:
	var event = InputEventKey.new()
	event.physical_keycode = key
	InputMap.action_erase_event(action, event)
