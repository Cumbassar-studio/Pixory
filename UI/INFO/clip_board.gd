extends Label

var text_to_copy: String = "gigachador02.2@gmail.com"

@onready var notification_popup = $"../Popup"
@onready var message_label = $"../Popup/Label"
@onready var auto_close_timer = $"../Timer"
@onready var info_panel = $".."

func _ready() -> void:
	auto_close_timer.timeout.connect(On_AutoCloseTimer_timeout)

func _input(click: InputEvent) -> void:
	if  info_panel.is_visible_in_tree():
		if click is InputEventMouseButton and click.pressed and click.button_index == MOUSE_BUTTON_LEFT:
			if get_global_rect().has_point(click.position):
				DisplayServer.clipboard_set(text_to_copy)
				message_label.text = "Скопировано в буфер"
				notification_popup.popup_centered()
				auto_close_timer.start(2.5)

func On_AutoCloseTimer_timeout() -> void:
	notification_popup.hide()
