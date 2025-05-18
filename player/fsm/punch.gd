# attach.gd
extends StatePlayer

var already_hit: bool = false

func enter(_msg: Dictionary= {}) -> void:
	
	if player.animation.is_flipped_h():
		player.punch_zone.set_scale(Vector2(-1, 1))
	else:
		player.punch_zone.set_scale(Vector2(1, 1))
	
	player.punch_zone.set_monitoring(true)
	




# Called every frame. 'delta' is the elapsed time since the previous frame.
func inner_physics_process(_delta):
	if not player.is_on_floor():
		state_machine.change_to("Air")

	player.animation.play("punch")
	
	player.velocity.x = move_toward(player.velocity.x, 0, player.ATTACK_INNERT)
	player.move_and_slide()



func _on_animated_sprite_2d_animation_finished():
	player.punch_zone.set_monitoring(false)
	if Input.is_action_just_pressed("ui_punch"):
		state_machine.change_to("Punch")
	elif Input.is_action_just_pressed("ui_jump"):
		state_machine.change_to("Jump", {do_jump=true})
	elif Input.is_action_pressed("ui_left") or Input.is_action_pressed("ui_right"):
		state_machine.change_to("Run")
	else:
		state_machine.change_to("Idle")


func _on_punch_area_entered(area: Area2D) -> void:
	print(area.owner.name)
	area.hit()
