class_name GamePlayerState
extends GameCharacterState


func _jump():
	actor.velocity.y = actor.jump_velocity
	actor.jumps_made += 1
	actor.prim_coyote_timer.stop()


func _ledge_hop():
	actor.velocity.y = actor.jump_velocity


func _get_gravity() -> float:
	if actor.velocity.y < 0.0 or Input.is_action_pressed("jump"):
		return actor.jump_gravity
	else:
		return actor.fall_gravity


func _apply_coyote_time(type: int):
	# Apply Primary Coyote Time
	if type == 0:
		if GameSettings.is_prim_coyote_time_enabled:
			if actor.prim_coyote_timer.is_stopped() and not actor.had_prim_coyote_time and not actor.has_jumped:
				actor.prim_coyote_timer.start()
				actor.velocity.y = 0
				actor.had_prim_coyote_time = true
	# Apply Secondary Coyote Time
	if type == 1:
		if GameSettings.is_sec_coyote_time_enabled:
			if actor.sec_coyote_timer.is_stopped() and not actor.had_sec_coyote_time and not actor.has_jumped:
				actor.sec_coyote_timer.start()
				actor.velocity.y = 0
				actor.had_sec_coyote_time = true


func _apply_gravity(delta):
	if actor.prim_coyote_timer.is_stopped():
		if not actor.sec_coyote_timer.is_stopped():
			actor.velocity.y += _get_gravity() * delta * actor.sec_coyote_time_grav_mult
		else:
			actor.velocity.y += _get_gravity() * delta


func _get_x_input() -> float:
	return Input.get_action_strength("right") - Input.get_action_strength("left")


func _get_dir() -> Vector2:
	return Vector2(_get_x_input(), -1.0 if Input.is_action_just_pressed("jump") and state_machine.actor.has_jumped else 1.0)
