extends StatePlayer


func enter(_msg: Dictionary={}):
	$"../../Debug/Vbox/L_state".set_text(name)
	pass

func inner_physics_process(delta):
	if not player.is_on_floor():
		state_machine.change_to("Air")

	if Input.is_action_just_pressed("ui_up"):
		state_machine.change_to("Air", {"do_jump" = true})

	var direction = Input.get_axis("ui_left", "ui_right")

	$"../../Debug/Vbox/L_dir".set_text(str(direction))
	if direction:
		player.velocity.x = lerp(player.velocity.x, direction * player.SPEED, player.ACCELERATION)
	else:
		player.velocity.x = move_toward(player.velocity.x, 0, player.RUN_INNERT)
	$"../../Debug/Vbox/L_vel".set_text(str(player.velocity))
	player.move_and_slide()
	
	if player.is_on_floor():
		if player.velocity.x == 0:
			state_machine.change_to("Idle")
		else:
			state_machine.change_to("Run")
