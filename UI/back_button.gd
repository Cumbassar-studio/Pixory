extends TextureButton

@onready var settings_panel = $/root/main_menu/Main/Panel

func _on_pressed() -> void:
	settings_panel.visible = not settings_panel.visible
