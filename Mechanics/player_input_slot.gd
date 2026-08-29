extends Node2D

var keys = {
	"a": KEY_A,
	"d": KEY_D,
	"space": KEY_SPACE
}
var actions = {
	"jump": "jump",
	"left": "move_left",
	"right": "move_right"
}

@export var action: String = "null"
@onready var label: Label = $Area2D/Label

func _ready() -> void:
	label.text = action

func _on_area_2d_body_entered(body: Node2D) -> void:
	if body.is_in_group("PlayerInputButton"):
		body.global_position = self.global_position
		set_action(body.get_parent().key)
		
func _on_area_2d_body_exited(body: Node2D) -> void:
	if body.is_in_group("PlayerInputButton"):
		remove_action(body.get_parent().key)
		
func set_action(input: String) -> void:
	var key = keys[input.to_lower()]
	var event = InputEventKey.new()
	event.physical_keycode = key
	InputMap.action_add_event(actions[action.to_lower()], event)
	
func remove_action(input: String) -> void:
	var key = keys[input.to_lower()]
	var event = InputEventKey.new()
	event.physical_keycode = key
	InputMap.action_erase_event(actions[action.to_lower()], event)
