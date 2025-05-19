extends Area2D
func _ready():
	# Для body_entered
	connect("body_entered", _on_body_entered)

func _on_body_entered(body):
	if body.is_in_group("player"):
		body.add_coin(1)  # Передаем 1 монету
		#emit_signal("collected")
		queue_free()  # Удаляем монетку
