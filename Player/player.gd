extends CharacterBody2D

@export var speed: float = 300.0
@export var jump_velocity: float = -400.0
@export var gravity_multiplier: float = 1.0
@export var controls_reversed: bool = false
var gravity: float = ProjectSettings.get_setting("physics/2d/default_gravity")


func _physics_process(delta: float) -> void:
	_apply_gravity(delta)
	_handle_jump(delta)
	_handle_horizontal_movement()
	move_and_slide()
	if Input.is_action_just_pressed("move_left"):
		print("should be moving")
 
func _apply_gravity(delta: float) -> void:
	velocity.y += gravity * gravity_multiplier * delta
 
func _handle_jump(delta: float) -> void:
		if Input.is_action_just_pressed("jump"):
			velocity.y += jump_velocity
 
func _handle_horizontal_movement() -> void:
	var input_dir: float = Input.get_axis("move_left", "move_right")
	if controls_reversed:
		input_dir = -input_dir
 
	if input_dir != 0.0:
		velocity.x = input_dir * speed
	else:
		velocity.x = move_toward(velocity.x, 0.0, speed)
