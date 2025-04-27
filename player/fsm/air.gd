extends StatePlayer

func enter(msg: Dictionary={}):
	if msg.has("do_jump"):
		player.velocity.y = player.JUMP_VELOCITY
	$"../../Debug/Vbox/L_state".set_text(name)

func inner_physics_process(delta):
	
	player.velocity.y += player.gravity * delta
	
	if player.is_on_floor():
		if player.velocity.x == 0:
			state_machine.change_to("Idle")
		else:
			state_machine.change_to("Run")
	
	if Input.is_action_just_pressed("ui_up") and player.is_on_floor():
		state_machine.change_to("Air", {do_jump = true})
	
	player.move_and_slide()
	
