extends Area2D

func _ready():
	# Для body_entered
	connect("body_entered", _on_body_entered)

func _on_body_entered(body: Node):
	print("Body entered:", body.name)
	queue_free()
