extends WorldEnvironment

@onready var Options_menu= $Options_menu as Control

func _ready():
	Options_menu.set_process(true)

func _input(event):
	if event.is_action_pressed("ui_cancel"):
		Options_menu.visible = !(Options_menu.visible)
