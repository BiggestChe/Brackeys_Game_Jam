extends Control

@export var audio_bus_name: String = "Narrator"
@export var expanded_width: float = 220.0
@export var collapsed_width: float = 0.0
@export var animation_duration: float = 0.25
 
## Optional: for puzzles like "mute to a specific number to reveal something".
## Set to -1 to disable. Fires target_percentage_reached once, the first
## time the slider lands within 1% of this value.
@export var target_reveal_percentage: float = 8.0
signal target_percentage_reached(value: float)
 
var _expanded: bool = false
var _bus_index: int = -1
var _tween: Tween
var _reveal_fired: bool = false
 
@onready var _icon_button: TextureButton = $Icon
@onready var _slider_panel: Control = $Slider
@onready var _slider: VSlider = $Slider/VSlider
@onready var _percent_label: Label = $Slider/Label

func _ready() -> void:
	_bus_index = AudioServer.get_bus_index(audio_bus_name)
	if _bus_index == -1:
		push_warning("VolumeSliderUI: audio bus '%s' not found." % audio_bus_name)
 	
	if _slider:
		print("slider found")
	_slider.min_value = 0
	_slider.max_value = 100
	_slider.step = 1
 
	_slider_panel.clip_contents = false
	_slider_panel.custom_minimum_size.x = collapsed_width
	_slider_panel.size.x = collapsed_width
	_slider_panel.modulate.a = 0.0
 
	_icon_button.pressed.connect(_on_icon_pressed)
	_slider.value_changed.connect(_on_slider_value_changed)
 
	_sync_slider_to_current_bus_state()
 
func _sync_slider_to_current_bus_state() -> void:
	if _bus_index == -1:
		_update_percent_label(_slider.value)
		return
 
	if AudioServer.is_bus_mute(_bus_index):
		_slider.value = 0.0
	else:
		var current_db: float = AudioServer.get_bus_volume_db(_bus_index)
		_slider.value = db_to_linear(current_db) * 100.0
 
	_update_percent_label(_slider.value)
 
func _on_icon_pressed() -> void:
	_expanded = not _expanded
	print("i am clicking on this")
 
	if _tween:
		_tween.kill()
 
	var target_width: float = expanded_width if _expanded else collapsed_width
	var target_alpha: float = 1.0 if _expanded else 0.0
 
	#uses tween to steadily elongate the slider
	_tween = create_tween()
	_tween.set_parallel(true)
	_tween.tween_property(_slider_panel, "custom_minimum_size:x", target_width, animation_duration)
	_tween.tween_property(_slider_panel, "size:x", target_width, animation_duration)
	_tween.tween_property(_slider_panel, "modulate:a", target_alpha, animation_duration)
 

func _on_slider_value_changed(value: float) -> void:
	_update_percent_label(value)
	_apply_volume(value)
	_check_reveal_threshold(value)
 
#applies volume change to AudioServer which finds Narrator audio bus at start
func _apply_volume(value: float) -> void:
	if _bus_index == -1:
		return
 
	if value <= 0.0:
		AudioServer.set_bus_mute(_bus_index, true)
	else:
		AudioServer.set_bus_mute(_bus_index, false)
		AudioServer.set_bus_volume_db(_bus_index, linear_to_db(value / 100.0))
 
func _update_percent_label(value: float) -> void:
	_percent_label.text = "%d%%" % int(round(value))
 
func _check_reveal_threshold(value: float) -> void:
	if target_reveal_percentage < 0.0 or _reveal_fired:
		return
	if abs(value - target_reveal_percentage) < 1.0:
		_reveal_fired = true
		DialogueSystem.say_true("narrator_reveal_1")
		target_percentage_reached.emit(value)
