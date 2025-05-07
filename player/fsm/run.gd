extends StatePlayer

func enter(_msg: Dictionary = {}) -> void:
	$"../../Debug/Vbox/L_state".set_text(name)

func inner_physics_process(_delta) -> void:
	var direction = Input.get_axis("ui_left", "ui_right")
	var is_sprinting = Input.is_action_pressed("ui_shift")
	
	var target_speed = player.SPRINT_SPEED if is_sprinting else player.SPEED

	# Логика движения
	if direction != 0:
		player.velocity.x = lerp(player.velocity.x, direction * target_speed, player.ACCELERATION)
	else:
		player.velocity.x = move_toward(player.velocity.x, 0, player.RUN_INNERT)
	
	# Обновляем дебаг-инфу
	$"../../Debug/Vbox/L_dir".set_text(str(direction))
	$"../../Debug/Vbox/L_vel".set_text(str(player.velocity))

	# Запускаем анимацию
	if direction != 0:
		if is_sprinting:
			player.animation.play("run")
		else:
			player.animation.play("walk")
	else:
		player.animation.stop()
	
	# Смена направления спрайта
	if direction < 0 and not player.animation.is_flipped_h():
		player.animation.set_flip_h(true)
		player.u_turn.emit("left")
	elif direction > 0 and player.animation.is_flipped_h():
		player.animation.set_flip_h(false)
		player.u_turn.emit("right")

	# Перемещаем персонажа
	player.move_and_slide()

	# Смена состояния, если персонаж на полу
	if player.is_on_floor():
		if player.velocity.x == 0:
			state_machine.change_to("Idle")
		else:
			state_machine.change_to("Run")
	else:
		state_machine.change_to("Air")

	# Прыжок
	if Input.is_action_just_pressed("ui_up") and player.is_on_floor():
		state_machine.change_to("Air", {"do_jump": true})
