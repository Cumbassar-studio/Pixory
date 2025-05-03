class_name Player
extends CharacterBody2D

#const JUMP_VELOCITY = -400.0
const ACCELERATION = 0.5
const RUN_INNERT = 8
const JUMP_INNERT = 8
const NORMAL_SPEED = 300.0
const CROUCH_SPEED = 150.0
const RUN_SPEED = 500.0
const JUMP_FORCE = 300.0
const MAX_JUMPS = 2  # Максимум 2 прыжка (обычный + двойной)

var gravity = 980
var jumps_left = MAX_JUMPS  # Оставшиеся прыжки
var is_crouching = false
var is_running = false
var speed
var push_force = 200.0

@onready var normal_collision = $CollisionShape2D.shape
@onready var crouch_collision = RectangleShape2D.new()

func _ready():
	crouch_collision.size = Vector2(normal_collision.size.x, normal_collision.size.y / 2)
	
func _physics_process(delta):
	if Input.is_action_pressed("ui_down"):
		enter_crouch()
	else:
		exit_crouch()
	is_running = Input.is_action_pressed("ui_run")
	match [is_running, is_crouching]:
		[true, false]:
			speed = RUN_SPEED
		[false, true]:
			speed = CROUCH_SPEED
		[true, true]: 
			speed = (RUN_SPEED + CROUCH_SPEED) / 2 
		_: # Все остальные случаи (по умолчанию)
			speed = NORMAL_SPEED
	if not is_on_floor():
		velocity.y += gravity * delta
	else:
		jumps_left = MAX_JUMPS
	var direction = Input.get_axis("ui_left", "ui_right")
	if direction:
		velocity.x = lerp(velocity.x, direction * speed, ACCELERATION)
	else:
		velocity.x = move_toward(velocity.x, 0, RUN_INNERT)
	if Input.is_action_just_pressed("ui_up"):
		if jumps_left > 0:
			velocity.y -= JUMP_FORCE
			jumps_left -= 1 # Тратим один прыжок
	move_and_slide()
	for i in get_slide_collision_count():
		var collision = get_slide_collision(i)
		if collision.get_collider() is RigidBody2D:
			var push_dir = -collision.get_normal()
			collision.get_collider().apply_central_impulse(push_dir * push_force)


func enter_crouch():
	if not is_crouching:
		is_crouching = true
		$CollisionShape2D.shape = crouch_collision



func exit_crouch():
	if is_crouching:
		var space_state = get_world_2d().direct_space_state
		var query = PhysicsRayQueryParameters2D.create(
			global_position,
			global_position + Vector2.UP * normal_collision.size.y)
		var result = space_state.intersect_ray(query)
		if result.is_empty():
			is_crouching = false
			$CollisionShape2D.shape = normal_collision
