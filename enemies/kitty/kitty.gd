extends CharacterBody2D

@export var shoot_interval = 1.0
@export var laser_speed = 400
@export var gravity: float = 1000.0
@onready var shoot_timer = $Timer
@onready var detection_area: Area2D = $DetectionArea
@onready var anim: AnimatedSprite2D = $animations
@onready var health_bar = $health_bar
@onready var hitbox = $HITBOX

var player: Node2D = null
var direction: int = 1
var hover_speed: float = 1000.0
var target_y: float = 0
var State = "grounded"

var max_health: int = 10
var health: int = max_health

func _ready() -> void:
	if not is_in_group("player"):
		add_to_group("player")
	detection_area.body_entered.connect(_on_detection_area_body_entered)
	detection_area.body_exited.connect(_on_detection_area_body_exited)
	hitbox.area_entered.connect(_on_hitbox_area_entered)
	
	if anim:
		anim.play("idle")
	shoot_timer.timeout.connect(_shoot_laser)

	health = max_health
	if health_bar:
		health_bar.min_value = 0
		health_bar.max_value = max_health
		health_bar.value = health

func update_health_bar():
	if health_bar:
		health_bar.value = health

func take_damage(amount: int) -> void:
	health -= amount
	health = max(0, health)
	print("Получен урон! HP осталось: ", health)
	update_health_bar()
	if health <= 0:
		die()

func die() -> void:
	print("Персонаж погиб.")
	queue_free()

func _physics_process(delta) -> void:
	match State:
		"grounded":
			if not is_on_floor():
				velocity.y += gravity * delta
			else:
				velocity.y = 0

		"flying_up":
			var epsilon := 5.0
			if position.y - target_y <= epsilon:
				shoot_timer.stop()
				shoot_timer.start(shoot_interval)
				velocity = Vector2.ZERO
				position.y = target_y
				State = "hover_shooting"
				return
			velocity = Vector2(0, -hover_speed * delta)

		"hover_shooting":
			velocity = Vector2.ZERO
			if player and direction != sign(player.position.x - position.x):
				direction = sign(player.position.x - position.x)
				anim.flip_h = direction > 0

	move_and_slide()

func _on_detection_area_body_entered(body: Node2D) -> void:
	if body.is_in_group("player"):
		player = body
		target_y = position.y - 100
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

	var laser_scene = preload("res://enemies/kitty/laser.tscn")
	var laser = laser_scene.instantiate()
	laser.global_position = $Marker2D.global_position
	laser.rotation = (player.global_position - laser.global_position).angle()
	laser.velocity = Vector2(laser_speed, 0).rotated(laser.rotation)
	get_tree().current_scene.add_child(laser)



func _on_hitbox_area_entered(area: Area2D) -> void:
	print("Вошёл объект: ", area.name)
	if area.has_method("deal_damage"):
		print("Получен удар от: ", area.name)
		take_damage(1)

func take_hit():
	take_damage(1)
