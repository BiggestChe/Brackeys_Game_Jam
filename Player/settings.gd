extends Area2D

var settings_list: Array[CanvasItem] = []

func _ready() -> void:
	await get_tree().process_frame
	custom_hide()

func _input(event: InputEvent) -> void:
	if Input.is_action_just_pressed("settings"):
		if visible:
			custom_hide()
		else:
			custom_show()

func custom_hide() -> void:
	hide()
	for item in settings_list:
		item.hide()
		
func custom_show() -> void:
	show()
	for item in settings_list:
		item.show()

func _on_body_entered(body: Node2D) -> void:
	settings_list.append(body)
	
func _on_body_exited(body: Node2D) -> void:
	settings_list.erase(body)
