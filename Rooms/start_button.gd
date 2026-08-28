extends Button

signal shattered
func _ready() -> void:
	pressed.connect(on_pressed)

##disable button press
func on_pressed():
	visible = false
	disabled = true
	shattered.emit(global_position)
