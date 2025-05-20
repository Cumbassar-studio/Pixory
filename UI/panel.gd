extends Panel

# Метод для открытия панели
func open_panel():
	show()

# Метод для закрытия панели
func close_panel():
	hide()

# Метод для обработки нажатия кнопки "Закрыть"
func _on_CloseButton_pressed():
	close_panel()
