extends Button

@onready var credits_popup: Node = $CreditsPopUp
@export var play_narrator_line_on_open: bool = true
@export var narrator_line_id: String = "menu_credits_look"

func _ready() -> void:
	if credits_popup:
		credits_popup.visible = false  # start closed
	pressed.connect(_on_pressed)

func _on_pressed() -> void:
	if credits_popup == null:
		push_warning("credits button aint here pal.")
		return

	credits_popup.visible = not credits_popup.visible

	if credits_popup.visible and play_narrator_line_on_open:
		DialogueSystem.say(narrator_line_id)
