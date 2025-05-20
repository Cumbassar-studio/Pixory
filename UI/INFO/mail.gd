extends Label

func _ready():
	set_process_input(true)
	
func _input(click: InputEvent) -> void:
	if click is InputEventMouseButton:
		if click.pressed and click.button_index == MOUSE_BUTTON_LEFT:
			var mouse_pos = click.position
			if get_global_rect().has_point(mouse_pos):
				OS.shell_open("https://github.com/Cumbassar-studio/Pixory")
