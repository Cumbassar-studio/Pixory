extends CharacterBody2D

@export var speed: float = 100.0
@export var gravity: float = 1000.0
@export var max_chase_distance: float = 500.0

@onready var detection_area: Area2D = $DetectionArea
@onready var hitbox = $Hitbox
@onready var anim: AnimatedSprite2D = $AnimatedSprite2D  # или AnimatedSprite2D
var player: Node2D = null

func _ready() -> void:
	hitbox.body_entered.connect(_on_hitbox_body_entered)
	detection_area.body_entered.connect(_on_detection_area_body_entered)
	detection_area.body_exited.connect(_on_detection_area_body_exited)

func _physics_process(delta) -> void:
	# Применяем гравитацию
	if not is_on_floor():
		velocity.y += gravity * delta
	else:
		velocity.y = 0  # сбрасываем, когда на полу

	if player and is_instance_valid(player):
		var distance = global_position.distance_to(player.global_position)

		if distance <= max_chase_distance and is_on_floor():
			var direction = (player.global_position.x - global_position.x)
			velocity.x = speed * sign(direction)

			if anim:
				anim.flip_h = direction > 0
				if anim.animation != "walk":
					anim.play("walk")
		else:
			velocity.x = 0
			if anim and anim.animation != "idle":
				anim.play("idle")
	else:
		velocity.x = 0
		if anim and anim.animation != "idle":
			anim.play("idle")

	move_and_slide()
	
func _on_hitbox_body_entered(body: Node) -> void:
	if body.has_method("take_damage"):
		body.take_damage(1)

func _on_detection_area_body_entered(body: Node) -> void:
	if body.is_in_group("player"):
		player = body

func _on_detection_area_body_exited(body: Node) -> void:
	if body == player:
		player = null
