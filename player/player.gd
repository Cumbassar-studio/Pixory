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


var gravity: float = 980
@onready var animation = $AnimatedSprite2D

signal u_turn
