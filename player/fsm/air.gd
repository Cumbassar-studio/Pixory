extends StatePlayer

func enter(msg: Dictionary={}):
	if msg.has("do_jump"):
		player.velocity.y = player.JUMP_VELOCITY
		player.JUMP_COUNT += 1  # Увеличиваем счётчик прыжков

func inner_physics_process(delta):
	
	# Анимация прыжка и падения
	if player.velocity.y < 0:
		player.animation.play("jump")
	else:
		player.animation.play("fall")
	
	player.velocity.y += player.gravity * delta  # Применяем гравитацию

	# Движение по оси X
	var direction = Input.get_axis("ui_left", "ui_right")
	if direction:
		player.velocity.x = lerp(player.velocity.x, direction * player.SPEED, player.ACCELERATION)
	else:
		player.velocity.x = move_toward(player.velocity.x, 0, player.JUMP_INNERT)

	# Смена направления спрайта
	if direction < 0 and not player.animation.is_flipped_h():
		player.animation.set_flip_h(true)
		player.u_turn.emit("left")
	elif direction > 0 and player.animation.is_flipped_h():
		player.animation.set_flip_h(false)
		player.u_turn.emit("right")

	# Прыжок при нажатии кнопки "вверх"
	if Input.is_action_just_pressed("ui_up") and player.JUMP_COUNT < player.MAX_JUMPS:
		state_machine.change_to("Air", {"do_jump": true})

	player.move_and_slide()

	# Проверка на пол
	if player.is_on_floor():
		player.JUMP_COUNT = 0  # Сбрасываем счётчик прыжков при касании земли
		if player.velocity.x == 0:
			state_machine.change_to("Idle")
		else:
			state_machine.change_to("Run")
