extends CharacterBody2D

@export var shoot_interval = 1.0
@export var laser_speed = 400
@onready var shoot_timer = $Timer
@export var gravity: float = 1000.0
@onready var detection_area: Area2D = $DetectionArea
@onready var anim: AnimatedSprite2D = $animations

var player: Node2D = null
var direction: int = 1 
var hover_speed: float = 1000.0
var target_y: float = 0
var State = "grounded"

var health: int = 10 # На этом мои полномочия всё

func _ready() -> void:
	detection_area.body_entered.connect(_on_detection_area_body_entered)
	detection_area.body_exited.connect(_on_detection_area_body_exited)
	if anim:
		anim.play("idle")
	shoot_timer.connect("timeout", Callable(self, "_shoot_laser"))

func _physics_process(delta) -> void:
	match State:
		"grounded":
			# Нормальное поведение с гравитацией
			if not is_on_floor():
				velocity.y += gravity * delta
			else:
				velocity.y = 0

		"flying_up":
			var epsilon := 5.0
			if position.y - target_y <= epsilon:
				shoot_timer.stop()
				shoot_timer.start(shoot_interval)
				# Мы достигли цели или очень близко
				velocity = Vector2.ZERO
				position = Vector2(position.x, target_y)  # Зафиксируем позицию
				State = "hover_shooting"
				shoot_timer.start(shoot_interval)
				return

			velocity = Vector2(0, -hover_speed * delta)

		"hover_shooting":
			velocity = Vector2.ZERO  # Полностью останавливаем
			# Поворот в сторону игрока (если нужен)
			if player and direction != sign(player.position.x - position.x):
				direction = sign(player.position.x - position.x)
				anim.flip_h = direction > 0

	move_and_slide()

func _on_detection_area_body_entered(body: Node2D) -> void:
	if body.is_in_group("player"):
		player = body
		target_y = position.y - 100  # Теперь это правильно
		State = "flying_up"
		if anim:
			anim.play("anger")

func _on_detection_area_body_exited(body: Node2D) -> void:
	if body.is_in_group("player"):
		player = null
		State = "grounded"
		shoot_timer.stop()
		if anim:
			anim.play("idle")

func _shoot_laser():
	if not player:
		return

	# Создаём лазер
	var laser_scene = preload("res://enemies/kitty/laser.tscn")
	var laser = laser_scene.instantiate()
	laser.position = $Marker2D.position
	laser.rotation = (player.position - position).angle()
	laser.velocity = Vector2(laser_speed, 0).rotated(laser.rotation)
	add_child(laser)
	
