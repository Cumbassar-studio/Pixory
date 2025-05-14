extends TextureButton

@onready var info_panel = $"../../info_panel" as Panel

func _on_pressed() -> void:
	info_panel.visible = not(info_panel.visible)
