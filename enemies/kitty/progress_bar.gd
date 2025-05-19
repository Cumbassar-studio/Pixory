extends ProgressBar
func _ready():
	# Настраиваем стили программно
	var background_style = StyleBoxFlat.new()
	background_style.bg_color = Color("#5a5a5a")  # Серый фон
	
	var fill_style = StyleBoxFlat.new()
	fill_style.bg_color = Color("#00ff00")  # Зелёное заполнение
	
	# Применяем стили
	add_theme_stylebox_override("background", background_style)
	add_theme_stylebox_override("fill", fill_style)
