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
var health: int = 10

var gravity: float = 980
@onready var animation = $AnimatedSprite2D


func take_damage(amount: int) -> void:
	health -= amount
	print("Игрок получил урон! Осталось HP: ", health)
	if health <= 0:
		die()

func die() -> void:
	print("Игрок погиб!")
	queue_free()
signal u_turn
