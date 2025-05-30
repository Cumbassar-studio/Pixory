class_name Player
extends CharacterBody2D

const SPEED: float = 200.0
const JUMP_VELOCITY: float = -400.0
const ACCELERATION: float = 0.5
const RUN_INNERT: int = 8
const JUMP_INNERT: int = 8
const BULLET_SPEED = 1000
const ATTACK_INNERT: float = 500.0

var JUMP_COUNT: int = 0
const MAX_JUMPS: int = 2
const SPRINT_SPEED: float = 400.0
var bottles: int = 0
var max_health: int = 10
var health: int = max_health
var gravity: float = 980
var has_crowbar: bool = false 

@onready var animation = $AnimatedSprite2D
@onready var bottle_label = $Debug/Vbox/BottleLabel
@onready var health_bar = $Debug/HealthBar
@onready var crowbar: PackedScene = preload("res://weapon/crowbar.tscn")
@onready var punch_zone = $Zones/Punch
@onready var jump_sound = $jump_sound
@onready var land_sound = $land_sound

func _ready():
	health = max_health
	if health_bar:
		health_bar.min_value = 0
		health_bar.max_value = max_health
		health_bar.value = health

func update_health_bar():
	if health_bar:
		health_bar.value = health

func _process(delta):
	if bottle_label: # Тоже, возможно, лишняя проверка
		bottle_label.text = "Пиво %d" % [bottles]

func add_coin(amount: int): # Можно переименовать в add_bottle
	bottles += amount
	print("Бутылки: ", bottles)

func take_damage(amount: int) -> void:
	health -= amount
	health = max(0, health)
	print("Игрок получил урон! Осталось HP: ", health)
	#emit_signal("health_changed", health, max_health) # Этот сигнал вызывается, но не объявлен.
	update_health_bar()
	if health <= 0:
		die()

func heal(amount: int) -> void:
	# health = min(health + amount, 10) # Лучше использовать max_health вместо 10
	health = min(health + amount, max_health)
	print("Здоровье: ", health)
	update_health_bar()

func die() -> void:
	print("Игрок погиб!")
	get_tree().change_scene_to_file("res://UI/main_menu.tscn")
	queue_free()
	

signal u_turn


func throw_crowbar():
	if not has_crowbar or crowbar == null:
		return
	has_crowbar = false

	var cb = crowbar.instantiate() as RigidBody2D

	var dir = -1 if animation.is_flipped_h() else 1
	var direction = Vector2(dir, -0.1).normalized()

	# сместим немного в сторону от игрока, чтобы не было коллизии сразу
	cb.position = global_position + Vector2(20 * dir, -5)

	cb.linear_velocity = direction * BULLET_SPEED
	cb.angular_velocity = 20  # Можно увеличить если нужен "полет с кручением"

	get_tree().current_scene.add_child(cb)
