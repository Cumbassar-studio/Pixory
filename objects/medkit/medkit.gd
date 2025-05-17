extends Area2D

func _ready():
	# Для body_entered
	connect("body_entered", _on_body_entered)

func _on_body_entered(body):
	# Проверяем, что это игрок
	if body.is_in_group("player"):
		body.heal(5)  # Восстановить 20 HP
		emit_signal("collected")
		queue_free()  # Удалить аптечку
