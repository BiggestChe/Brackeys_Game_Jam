extends Label

@export var chars_per_second: float = 30.0

var _tween: Tween

func _ready() -> void:
	visible = false
	visible_ratio = 0.0
	DialogueSystem.subtitle_requested.connect(_on_subtitle_requested)
	DialogueSystem.subtitle_cleared.connect(_on_subtitle_cleared)
	DialogueSystem.say("menu_start_fail_1")

func _on_subtitle_requested(new_text: String, speaker: String) -> void:
	if _tween:
		_tween.kill()

	self.text = new_text
	visible_ratio = 0.0
	visible = true

	if speaker == "true_narrator":
		add_theme_color_override("font_color", Color.RED)
	else:
		remove_theme_color_override("font_color")

	var duration: float = max(new_text.length() / chars_per_second, 0.01)
	_tween = create_tween()
	_tween.tween_property(self, "visible_ratio", 1.0, duration)

func _on_subtitle_cleared(_speaker: String) -> void:
	if _tween:
		_tween.kill()
	visible = false
