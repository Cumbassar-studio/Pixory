extends Area2D

var velocity: Vector2 = Vector2.ZERO
var damage: int = 1
@onready var laser: Area2D =$"."
@export var lifetime: float = 5.0
func _ready():
	laser.body_entered.connect(_on_body_entered)
	# Устанавливаем таймер на удаление лазера после истечения времени
	var timer = Timer.new()
	add_child(timer)
	timer.wait_time = lifetime
	timer.connect("timeout", Callable(self, "queue_free"))
	timer.start()

func _physics_process(delta):
	position += velocity * delta
	if position.x < -10000 || position.x > 10000 || position.y < -10000 || position.y > 10000:
		queue_free()

func _on_body_entered(body: Node2D):
	if body.is_in_group("player"):
		body.take_damage(damage) 
		queue_free()
