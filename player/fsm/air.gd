extends StatePlayer

func enter(msg: Dictionary={}):
	if msg.has("do_jump"):
		player.velocity.y = player.JUMP_VELOCITY
	$"../../Debug/Vbox/L_state".set_text(name)

func inner_physics_process(delta):
	
	player.velocity.y += player.gravity * delta
	
	player.move_and_slide()
	
	if player.is_on_floor():
		state_machine.change_to("idle")
