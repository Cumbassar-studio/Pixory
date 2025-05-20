extends StatePlayer


func enter(_msg: Dictionary={}):
	player.velocity = Vector2.ZERO
	$"../../Debug/Vbox/L_state".set_text(name)
func inner_physics_process(_delta):
	
	if Input.is_action_just_pressed("throw_item") and player.has_crowbar:
		player.throw_crowbar()
		player.animation.play("throw_crowbar")

	if not player.is_on_floor():
		state_machine.change_to("Air")
	
	if Input.is_action_just_pressed("ui_punch"):
		state_machine.change_to("Punch")
		
	if Input.is_action_just_pressed("ui_up"):
		state_machine.change_to("Air", {do_jump = true})
		
	if Input.is_action_pressed("ui_left") or Input.is_action_pressed("ui_right"):
		state_machine.change_to("Run")
		
	if player.has_crowbar:
		player.animation.play("idle_crowbar")
	else:
		player.animation.play("idle")
