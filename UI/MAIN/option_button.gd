extends TextureButton

@onready var Options_menu=$"../../Options_menu" as Control
@onready var logo = $"../../Logo" as Sprite2D

func _on_pressed() -> void:
	Options_menu.visible=true
	logo.visible = false
