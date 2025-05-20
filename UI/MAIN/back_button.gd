extends TextureButton

@onready var Options_menu=$"../.." as Control

func _ready() -> void:
	pass

func _on_pressed() -> void:
	Options_menu.visible=false
