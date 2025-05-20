extends OptionButton

func _ready() -> void:
	add_item("Window")
	add_item("Fullscreen")
	add_item("BL screen")

	if not item_selected.is_connected(_on_item_selected):
		item_selected.connect(_on_item_selected)

	var current_mode = DisplayServer.window_get_mode()
	var is_borderless = DisplayServer.window_get_flag(DisplayServer.WINDOW_FLAG_BORDERLESS)
	var window_size = DisplayServer.window_get_size()
	var screen_size = DisplayServer.screen_get_size(DisplayServer.window_get_current_screen())

	if current_mode == DisplayServer.WINDOW_MODE_WINDOWED:
		if is_borderless and window_size == screen_size:
			select(2)
		else:
			select(0)
	elif current_mode == DisplayServer.WINDOW_MODE_FULLSCREEN:
		select(1)

func _on_item_selected(index: int) -> void:
	match index:
		0: #Window
			DisplayServer.window_set_mode(DisplayServer.WINDOW_MODE_WINDOWED)
			DisplayServer.window_set_flag(DisplayServer.WINDOW_FLAG_BORDERLESS, false)
			DisplayServer.window_set_size(Vector2i(1280, 720)) 
			DisplayServer.window_set_position(DisplayServer.window_get_size() / 2) 
		1: #Fullscreen
			DisplayServer.window_set_mode(DisplayServer.WINDOW_MODE_FULLSCREEN)
			DisplayServer.window_set_flag(DisplayServer.WINDOW_FLAG_BORDERLESS, false)
		2: #Window borderless
			DisplayServer.window_set_mode(DisplayServer.WINDOW_MODE_WINDOWED)
			DisplayServer.window_set_flag(DisplayServer.WINDOW_FLAG_BORDERLESS, true)
			DisplayServer.window_set_position(Vector2i(0, 0))
			DisplayServer.window_set_size(DisplayServer.screen_get_size(DisplayServer.window_get_current_screen()))
