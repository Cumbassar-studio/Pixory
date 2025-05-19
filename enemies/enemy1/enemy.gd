extends CharacterBody2D

@export var speed: float = 100.0
@export var gravity: float = 1000.0
@export var max_chase_distance: float = 500.0
@onready var detection_area: Area2D = $DetectionArea
@onready var hitbox: Area2D = $Hitbox
@onready var anim: AnimatedSprite2D = $AnimatedSprite2D
@onready var edge_detector: RayCast2D = $EdgeDetector

var player: Node2D = null
var direction: int = 1 
var can_turn: bool = true

func _ready() -> void:
	hitbox.body_entered.connect(_on_hitbox_body_entered)
	detection_area.body_entered.connect(_on_detection_area_body_entered)
	detection_area.body_exited.connect(_on_detection_area_body_exited)
	# Создаём таймер
	var timer = Timer.new()
	add_child(timer)
	timer.wait_time = 0.2
	timer.connect("timeout", Callable(self, "_on_timer_timeout"))
	timer.start()
	
func _physics_process(delta) -> void:
	
	# Гравитация
	if not is_on_floor():
		velocity.y += gravity * delta
	else:
		velocity.y = 0
	# Если игрок найден — гонимся за ним
	if player and is_instance_valid(player):
		var distance = global_position.distance_to(player.global_position)
		if distance <= max_chase_distance and is_on_floor():
			var direction_to_player = (player.global_position.x - global_position.x)
			velocity.x = speed * sign(direction_to_player)
			if anim:
				anim.flip_h = direction_to_player > 0
				if anim.animation != "walk":
					anim.play("walk")
		else:
			velocity.x = 0
			if anim and anim.animation != "idle":
				anim.play("idle")
	# Иначе — патрулируем
	else:
		if is_on_floor():
			velocity.x = speed * direction
			if anim:
				anim.flip_h = direction > 0
				if anim.animation != "walk":
					anim.play("walk")
		else:
			if anim and anim.animation != "idle":
				anim.play("idle")
	# Проверяем столкновение со стеной и разворачиваемся
	if velocity.x != 0 && is_on_wall() && can_turn:
		turn_around()
	# Проверяем край платформы
	if is_on_floor() && can_turn:
		if !edge_detector.is_colliding():
			turn_around()
	move_and_slide()
			
func turn_around():
	direction *= -1
	if anim:
		anim.flip_h = direction < 0
	can_turn = false

func _on_hitbox_body_entered(body: Node2D) -> void:
	if body.is_in_group("player"):
		body.take_damage(1)

func _on_detection_area_body_entered(body: Node2D) -> void:
	if body.is_in_group("player"):
		player = body

func _on_detection_area_body_exited(body: Node2D) -> void:
	if body == player:
		player = null

func _on_timer_timeout():
	can_turn = true
	#print("can_turn изменена на: ", can_turn)
