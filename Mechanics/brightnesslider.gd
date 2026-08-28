extends Node2D

@onready var h_slider: HSlider = $DraggablePhysicsBody2D/HSlider
@onready var bar_collider: CollisionShape2D = $DraggablePhysicsBody2D/barCollider
@onready var handle_collider: CollisionShape2D = $DraggablePhysicsBody2D/handleCollider

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	var px_size = h_slider.size * h_slider.scale
	var t = Transform2D(0, 	Vector2(0.001, 1), 0, Vector2(-px_size.x / 2, 0))
	bar_collider.transform = t


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass

func _on_h_slider_value_changed(value: float) -> void:
	var px_size = h_slider.size * h_slider.scale
	var t = Transform2D(0, 	Vector2(value / 105, 1), 0, Vector2((px_size.x * ((value / 105) - 1)) / 2, 0))
	bar_collider.transform = t
	
	t = Transform2D(0, 	Vector2(px_size.x * (((value + 3) / 106) - .5), 0))
	handle_collider.transform = t
