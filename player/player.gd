class_name Player
extends CharacterBody2D

const SPEED: float = 200.0
const JUMP_VELOCITY: float = -400.0
const ACCELERATION: float = 0.5
const RUN_INNERT: int = 8
const JUMP_INNERT: int = 8
var JUMP_COUNT: int = 0
const MAX_JUMPS: int = 2
const SPRINT_SPEED: float = 400.0
var bottles: int = 0

var max_health: int = 10
var health: int = max_health
var gravity: float = 980

@onready var animation = $AnimatedSprite2D
@onready var bottle_label = $Debug/Vbox/BottleLabel 
@onready var health_bar = $Debug/HealthBar

func _ready():
	health = max_health
	if health_bar:
		health_bar.max_value = max_health
		health_bar.value = max_health
	update_health_bar()
	
func update_health_bar():
	if health_bar:
		health_bar.value = health
	
func _process(delta):
	if bottle_label:
		bottle_label.text = "Пиво %d" % [bottles]

func add_coin(amount: int):
	bottles += amount
	print("Бутылки: ", bottles)

func take_damage(amount: int) -> void:
	health -= amount
	health = max(0, health)
	print("Игрок получил урон! Осталось HP: ", health)
	emit_signal("health_changed", health, max_health)
	update_health_bar()
	if health <= 0:
		die()
		
func heal(amount: int) -> void:
	health = min(health + amount, 10)  # Восстанавливаем до максимума
	print("Здоровье: ", health)
	update_health_bar()
	
func die() -> void:
	print("Игрок погиб!")
	queue_free()
signal u_turn
