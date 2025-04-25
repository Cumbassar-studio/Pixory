extends StatePlayer

func enter(msg: Dictionary={}):
	if msg.has("do_jump"):
		player.velocity.y = player.JUMP_VELOCITY
	$"../../Debug/Vbox/L_state".set_text(name)

func inner_physics_process(delta):
	
	player.velocity.y += player.gravity * delta
	
	player.move_and_slide()
	
	if player.is_on_floor():
		state_machine.change_to("Idle")
	
	if Input.is_action_just_pressed("ui_up"):
		state_machine.change_to("Air", {do_jump = true})
		
	if Input.is_action_pressed("ui_left") or Input.is_action_pressed("ui_right"):
		state_machine.change_to("Run")
