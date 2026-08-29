extends Node2D

@onready var label: Label = $DraggablePhysicsBody2D/Label
@export var key: String = "null"

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	label.text = key
	if (key.length() > 1):
		label.add_theme_font_size_override("font_size", 16)
